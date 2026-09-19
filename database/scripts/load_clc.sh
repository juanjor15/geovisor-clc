#!/usr/bin/env bash
set -euo pipefail

: "${POSTGRES_HOST:=postgis}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:=geovisor}"
: "${POSTGRES_USER:=geovisor}"
: "${POSTGRES_PASSWORD:=geovisor}"
: "${POSTGRES_SCHEMA:=gis}"
: "${POSTGRES_TABLE:=land_cover}"
: "${DATA_GPKG_PATH:=/data/sample/CLC_2018.gpkg}"
: "${DATA_GPKG_LAYER:=clc_2018_pereira}"
: "${DATA_SRID:=9377}"

export PGPASSWORD="${POSTGRES_PASSWORD}"

RAW_TABLE="${POSTGRES_TABLE}_raw"
PG_CONN="PG:host=${POSTGRES_HOST} port=${POSTGRES_PORT} dbname=${POSTGRES_DB} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}"

validate_loaded_layer() {
  source_path="$1"
  source_layer="$2"
  target_table="$3"

  expected_count="$(ogrinfo -ro -so "${source_path}" "${source_layer}" | awk '/Feature Count:/ { print $3; exit }')"
  if ! [[ "${expected_count}" =~ ^[0-9]+$ ]]; then
    echo "Could not determine feature count for ${source_path}:${source_layer}" >&2
    exit 1
  fi

  validation="$(
    psql \
      --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" \
      --dbname="${POSTGRES_DB}" --username="${POSTGRES_USER}" \
      --tuples-only --no-align --field-separator='|' \
      --command="SELECT count(*), count(*) FILTER (WHERE NOT ST_IsValid(geom)), count(*) FILTER (WHERE ST_SRID(geom) <> ${DATA_SRID}) FROM ${POSTGRES_SCHEMA}.${target_table};"
  )"
  validation="${validation# }"
  loaded_count="${validation%%|*}"
  remainder="${validation#*|}"
  invalid_count="${remainder%%|*}"
  wrong_srid_count="${remainder##*|}"

  if [[ "${loaded_count}" != "${expected_count}" ]]; then
    echo "Unexpected feature count in ${target_table}: ${loaded_count}. Source layer has ${expected_count}." >&2
    exit 1
  fi
  if [[ "${invalid_count}" != "0" ]]; then
    echo "Invalid geometries found in ${target_table}: ${invalid_count}" >&2
    exit 1
  fi
  if [[ "${wrong_srid_count}" != "0" ]]; then
    echo "Geometries with wrong SRID found in ${target_table}: ${wrong_srid_count}" >&2
    exit 1
  fi

  echo "Validated ${loaded_count} features in ${POSTGRES_SCHEMA}.${target_table} with SRID ${DATA_SRID}."
}

until pg_isready \
  --host="${POSTGRES_HOST}" \
  --port="${POSTGRES_PORT}" \
  --dbname="${POSTGRES_DB}" \
  --username="${POSTGRES_USER}"; do
  sleep 2
done

psql \
  --host="${POSTGRES_HOST}" \
  --port="${POSTGRES_PORT}" \
  --dbname="${POSTGRES_DB}" \
  --username="${POSTGRES_USER}" \
  --set=ON_ERROR_STOP=1 <<SQL
CREATE EXTENSION IF NOT EXISTS postgis;
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext)
VALUES (
    9377,
    'EPSG',
    9377,
    '+proj=tmerc +lat_0=4 +lon_0=-73 +k=0.9992 +x_0=5000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs',
    'PROJCS["MAGNA-SIRGAS 2018 / Origen-Nacional",GEOGCS["MAGNA-SIRGAS 2018",DATUM["Marco_Geocentrico_Nacional_de_Referencia_2018",SPHEROID["GRS 1980",6378137,298.257222101],TOWGS84[0,0,0,0,0,0,0]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","20046"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",4],PARAMETER["central_meridian",-73],PARAMETER["scale_factor",0.9992],PARAMETER["false_easting",5000000],PARAMETER["false_northing",2000000],UNIT["metre",1,AUTHORITY["EPSG","9001"]],AUTHORITY["EPSG","9377"]]'
)
ON CONFLICT (srid) DO UPDATE
SET
    auth_name = EXCLUDED.auth_name,
    auth_srid = EXCLUDED.auth_srid,
    proj4text = EXCLUDED.proj4text,
    srtext = EXCLUDED.srtext;
CREATE SCHEMA IF NOT EXISTS ${POSTGRES_SCHEMA};
DROP TABLE IF EXISTS ${POSTGRES_SCHEMA}.${POSTGRES_TABLE} CASCADE;
DROP TABLE IF EXISTS ${POSTGRES_SCHEMA}.${RAW_TABLE} CASCADE;
SQL

ogr2ogr \
  -f PostgreSQL "${PG_CONN}" \
  "${DATA_GPKG_PATH}" "${DATA_GPKG_LAYER}" \
  -nln "${POSTGRES_SCHEMA}.${RAW_TABLE}" \
  -nlt MULTIPOLYGON \
  -t_srs "EPSG:${DATA_SRID}" \
  -lco GEOMETRY_NAME=geom \
  -lco FID=fid \
  -lco LAUNDER=YES \
  -overwrite

psql \
  --host="${POSTGRES_HOST}" \
  --port="${POSTGRES_PORT}" \
  --dbname="${POSTGRES_DB}" \
  --username="${POSTGRES_USER}" \
  --set=ON_ERROR_STOP=1 \
  --set=schema="${POSTGRES_SCHEMA}" \
  --set=table="${POSTGRES_TABLE}" \
  --set=raw_table="${RAW_TABLE}" \
  --set=srid="${DATA_SRID}" <<'SQL'
CREATE TABLE :"schema".:"table" (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_fid integer,
    codigo integer,
    leyenda text,
    insumo text,
    apoyo text,
    confiabili text,
    cambio text,
    nivel_1 text,
    nivel_2 text,
    nivel_3 text,
    nivel_4 text,
    nivel_5 text,
    nivel_6 text,
    shape_leng double precision,
    area_m2 double precision,
    area_ha double precision,
    geom geometry(MultiPolygon, :srid) NOT NULL
);

INSERT INTO :"schema".:"table" (
    source_fid,
    codigo,
    leyenda,
    insumo,
    apoyo,
    confiabili,
    cambio,
    nivel_1,
    nivel_2,
    nivel_3,
    nivel_4,
    nivel_5,
    nivel_6,
    shape_leng,
    area_m2,
    area_ha,
    geom
)
SELECT
    fid::integer AS source_fid,
    codigo::integer,
    leyenda::text,
    insumo::text,
    apoyo::text,
    confiabili::text,
    cambio::text,
    nivel_1::text,
    nivel_2::text,
    nivel_3::text,
    nivel_4::text,
    nivel_5::text,
    nivel_6::text,
    shape_leng::double precision,
    ST_Area(ST_SetSRID(ST_Multi(ST_MakeValid(geom)), :srid)::geometry(MultiPolygon, :srid))::double precision AS area_m2,
    (ST_Area(ST_SetSRID(ST_Multi(ST_MakeValid(geom)), :srid)::geometry(MultiPolygon, :srid)) / 10000.0)::double precision AS area_ha,
    ST_SetSRID(ST_Multi(ST_MakeValid(geom)), :srid)::geometry(MultiPolygon, :srid) AS geom
FROM :"schema".:"raw_table"
WHERE geom IS NOT NULL;

CREATE INDEX land_cover_geom_gix
    ON :"schema".:"table"
    USING GIST (geom);

CREATE INDEX land_cover_codigo_idx
    ON :"schema".:"table" (codigo);

CREATE INDEX land_cover_leyenda_idx
    ON :"schema".:"table" (leyenda);

ANALYZE :"schema".:"table";

DROP TABLE :"schema".:"raw_table";
SQL

validate_loaded_layer "${DATA_GPKG_PATH}" "${DATA_GPKG_LAYER}" "${POSTGRES_TABLE}"

# Every additional GeoPackage in data/sample is imported as an independent
# PostGIS table.  The file name is the public layer id (sanitized to a SQL
# identifier) and a same-named SLD is picked up by the GeoServer provisioner.
psql \
  --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" \
  --dbname="${POSTGRES_DB}" --username="${POSTGRES_USER}" \
  --set=ON_ERROR_STOP=1 <<SQL
CREATE TABLE IF NOT EXISTS ${POSTGRES_SCHEMA}.layer_catalog (
    layer_name text PRIMARY KEY,
    title text NOT NULL,
    style_name text,
    source_file text NOT NULL,
    is_primary boolean NOT NULL DEFAULT false
);
TRUNCATE ${POSTGRES_SCHEMA}.layer_catalog;
INSERT INTO ${POSTGRES_SCHEMA}.layer_catalog
    (layer_name, title, style_name, source_file, is_primary)
VALUES
    ('${POSTGRES_TABLE}', 'Coberturas CLC 2018', '${GEOSERVER_STYLE:-CLC_2018}',
     '$(basename "${DATA_GPKG_PATH}")', true);
SQL

for gpkg_path in /data/sample/*.gpkg; do
  [ -f "${gpkg_path}" ] || continue
  if [ "${gpkg_path}" = "${DATA_GPKG_PATH}" ]; then
    continue
  fi

  file_stem="$(basename "${gpkg_path}" .gpkg)"
  table_name="$(printf '%s' "${file_stem}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g; s/^[0-9]/layer_&/')"
  title="$(printf '%s' "${file_stem}" | tr '_' ' ')"
  source_layer="$(ogrinfo -ro -q "${gpkg_path}" | sed -n 's/^[0-9][0-9]*: \([^ ]*\).*/\1/p' | head -n 1)"
  matching_layer="$(ogrinfo -ro -q "${gpkg_path}" | sed -n 's/^[0-9][0-9]*: \([^ ]*\).*/\1/p' | awk -v wanted="${table_name}" 'tolower($0) == wanted { print; exit }')"
  [ -z "${matching_layer}" ] || source_layer="${matching_layer}"

  if [ -z "${source_layer}" ]; then
    echo "No feature layer found in ${gpkg_path}" >&2
    exit 1
  fi

  ogr2ogr -f PostgreSQL "${PG_CONN}" "${gpkg_path}" "${source_layer}" \
    -nln "${POSTGRES_SCHEMA}.${table_name}" \
    -nlt PROMOTE_TO_MULTI -t_srs "EPSG:${DATA_SRID}" \
    -lco GEOMETRY_NAME=geom -lco LAUNDER=YES -overwrite

  # Some GDAL/PostGIS combinations register an equivalent custom SRID even
  # after -t_srs. Normalize the geometry metadata to the configured EPSG id.
  psql \
    --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" \
    --dbname="${POSTGRES_DB}" --username="${POSTGRES_USER}" \
    --set=ON_ERROR_STOP=1 \
    --command="SELECT UpdateGeometrySRID('${POSTGRES_SCHEMA}', '${table_name}', 'geom', ${DATA_SRID});" \
    >/dev/null

  validate_loaded_layer "${gpkg_path}" "${source_layer}" "${table_name}"

  style_name=""
  [ ! -f "/data/sample/${file_stem}.sld" ] || style_name="${file_stem}"
  psql \
    --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" \
    --dbname="${POSTGRES_DB}" --username="${POSTGRES_USER}" \
    --set=ON_ERROR_STOP=1 \
    --set=schema="${POSTGRES_SCHEMA}" \
    --set=layer_name="${table_name}" --set=title="${title}" \
    --set=style_name="${style_name}" --set=source_file="$(basename "${gpkg_path}")" <<'SQL'
INSERT INTO :"schema".layer_catalog (layer_name, title, style_name, source_file, is_primary)
VALUES (:'layer_name', :'title', NULLIF(:'style_name', ''), :'source_file', false)
ON CONFLICT (layer_name) DO UPDATE SET
    title = EXCLUDED.title,
    style_name = EXCLUDED.style_name,
    source_file = EXCLUDED.source_file,
    is_primary = false;
SQL
  echo "Loaded automatic layer ${source_layer} as ${POSTGRES_SCHEMA}.${table_name}."
done
