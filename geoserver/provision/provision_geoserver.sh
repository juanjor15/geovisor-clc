#!/usr/bin/env sh
set -eu

: "${GEOSERVER_URL:=http://geoserver:8080/geoserver}"
: "${GEOSERVER_ADMIN_USER:=admin}"
: "${GEOSERVER_ADMIN_PASSWORD:=geoserver}"
: "${GEOSERVER_WORKSPACE:=clc}"
: "${GEOSERVER_DATASTORE:=postgis}"
: "${GEOSERVER_LAYER:=land_cover}"
: "${GEOSERVER_STYLE:=CLC_2018}"
: "${POSTGRES_HOST:=postgis}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:=geovisor}"
: "${POSTGRES_USER:=geovisor}"
: "${POSTGRES_PASSWORD:=geovisor}"
: "${POSTGRES_SCHEMA:=gis}"
: "${DATA_SRID:=9377}"
: "${GEOSERVER_SLD_PATH:=/opt/geoserver_styles/CLC_2018.sld}"
: "${DATA_GPKG_PATH:=/data/sample/CLC_2018.gpkg}"
: "${GEOSERVER_LAYER_TITLE:=Coberturas CLC 2018}"

REST_URL="${GEOSERVER_URL%/}/rest"
AUTH="${GEOSERVER_ADMIN_USER}:${GEOSERVER_ADMIN_PASSWORD}"

request_status() {
  method="$1"
  url="$2"
  content_type="${3:-}"
  body="${4:-}"

  if [ -n "${body}" ]; then
    curl -sS -u "${AUTH}" -o /tmp/geoserver_response.txt -w "%{http_code}" \
      -X "${method}" \
      -H "Content-Type: ${content_type}" \
      --data "${body}" \
      "${url}"
  else
    curl -sS -u "${AUTH}" -o /tmp/geoserver_response.txt -w "%{http_code}" \
      -X "${method}" \
      "${url}"
  fi
}

upload_status() {
  method="$1"
  url="$2"
  content_type="$3"
  file_path="$4"

  curl -sS -u "${AUTH}" -o /tmp/geoserver_response.txt -w "%{http_code}" \
    -X "${method}" \
    -H "Content-Type: ${content_type}" \
    --data-binary "@${file_path}" \
    "${url}"
}

assert_success() {
  status="$1"
  action="$2"
  case "${status}" in
    200|201|202)
      echo "${action}: ok (${status})"
      ;;
    *)
      echo "${action}: failed (${status})" >&2
      cat /tmp/geoserver_response.txt >&2 || true
      exit 1
      ;;
  esac
}

wait_for_geoserver() {
  retries=60
  while [ "${retries}" -gt 0 ]; do
    status="$(request_status GET "${REST_URL}/about/version.xml")"
    if [ "${status}" = "200" ]; then
      echo "GeoServer REST API is ready."
      return 0
    fi
    retries=$((retries - 1))
    sleep 2
  done

  echo "GeoServer REST API did not become ready." >&2
  exit 1
}

create_workspace() {
  status="$(request_status GET "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}.xml")"
  if [ "${status}" = "200" ]; then
    echo "Workspace ${GEOSERVER_WORKSPACE}: exists."
    return 0
  fi

  body="<workspace><name>${GEOSERVER_WORKSPACE}</name></workspace>"
  status="$(request_status POST "${REST_URL}/workspaces" "application/xml" "${body}")"
  assert_success "${status}" "Workspace ${GEOSERVER_WORKSPACE}"
}

create_datastore() {
  body="<dataStore>
  <name>${GEOSERVER_DATASTORE}</name>
  <enabled>true</enabled>
  <connectionParameters>
    <entry key=\"host\">${POSTGRES_HOST}</entry>
    <entry key=\"port\">${POSTGRES_PORT}</entry>
    <entry key=\"database\">${POSTGRES_DB}</entry>
    <entry key=\"user\">${POSTGRES_USER}</entry>
    <entry key=\"passwd\">${POSTGRES_PASSWORD}</entry>
    <entry key=\"dbtype\">postgis</entry>
    <entry key=\"schema\">${POSTGRES_SCHEMA}</entry>
    <entry key=\"Expose primary keys\">true</entry>
  </connectionParameters>
</dataStore>"

  status="$(request_status GET "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/datastores/${GEOSERVER_DATASTORE}.xml")"
  if [ "${status}" = "200" ]; then
    status="$(request_status PUT "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/datastores/${GEOSERVER_DATASTORE}.xml" "application/xml" "${body}")"
    assert_success "${status}" "Datastore ${GEOSERVER_DATASTORE} update"
    return 0
  fi

  status="$(request_status POST "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/datastores" "application/xml" "${body}")"
  assert_success "${status}" "Datastore ${GEOSERVER_DATASTORE}"
}

publish_featuretype() {
  status="$(request_status GET "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/datastores/${GEOSERVER_DATASTORE}/featuretypes/${GEOSERVER_LAYER}.xml")"
  if [ "${status}" = "200" ]; then
    echo "Feature type ${GEOSERVER_LAYER}: exists."
    return 0
  fi

  body="<featureType>
  <name>${GEOSERVER_LAYER}</name>
  <nativeName>${GEOSERVER_LAYER}</nativeName>
  <title>${GEOSERVER_LAYER_TITLE}</title>
  <abstract>Capa geoespacial publicada automaticamente desde PostGIS.</abstract>
  <srs>EPSG:${DATA_SRID}</srs>
  <projectionPolicy>FORCE_DECLARED</projectionPolicy>
  <enabled>true</enabled>
</featureType>"

  status="$(request_status POST "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/datastores/${GEOSERVER_DATASTORE}/featuretypes" "application/xml" "${body}")"
  assert_success "${status}" "Feature type ${GEOSERVER_LAYER}"
}

publish_style() {
  if [ ! -f "${GEOSERVER_SLD_PATH}" ]; then
    echo "SLD file not found: ${GEOSERVER_SLD_PATH}" >&2
    exit 1
  fi

  style_content_type="application/vnd.ogc.sld+xml"
  if grep -q 'version="1\.1\.0"' "${GEOSERVER_SLD_PATH}"; then
    style_content_type="application/vnd.ogc.se+xml"
  fi

  status="$(request_status GET "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/styles/${GEOSERVER_STYLE}.xml")"
  if [ "${status}" = "200" ]; then
    status="$(upload_status PUT "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/styles/${GEOSERVER_STYLE}" "${style_content_type}" "${GEOSERVER_SLD_PATH}")"
    assert_success "${status}" "Style ${GEOSERVER_STYLE} update"
    return 0
  fi

  status="$(upload_status POST "${REST_URL}/workspaces/${GEOSERVER_WORKSPACE}/styles?name=${GEOSERVER_STYLE}" "${style_content_type}" "${GEOSERVER_SLD_PATH}")"
  assert_success "${status}" "Style ${GEOSERVER_STYLE}"
}

assign_style() {
  body="<layer>
  <defaultStyle>
    <name>${GEOSERVER_STYLE}</name>
    <workspace>${GEOSERVER_WORKSPACE}</workspace>
  </defaultStyle>
  <enabled>true</enabled>
</layer>"

  status="$(request_status PUT "${REST_URL}/layers/${GEOSERVER_WORKSPACE}:${GEOSERVER_LAYER}.xml" "application/xml" "${body}")"
  assert_success "${status}" "Layer style assignment"
}

validate_publication() {
  status="$(request_status GET "${GEOSERVER_URL%/}/${GEOSERVER_WORKSPACE}/wms?service=WMS&version=1.3.0&request=GetCapabilities")"
  assert_success "${status}" "WMS GetCapabilities"

  status="$(request_status GET "${GEOSERVER_URL%/}/${GEOSERVER_WORKSPACE}/wfs?service=WFS&version=2.0.0&request=GetFeature&typeNames=${GEOSERVER_WORKSPACE}:${GEOSERVER_LAYER}&count=1")"
  assert_success "${status}" "WFS GetFeature"
}

wait_for_geoserver
create_workspace
create_datastore
publish_featuretype
publish_style
assign_style
validate_publication

echo "GeoServer provisioning completed for ${GEOSERVER_WORKSPACE}:${GEOSERVER_LAYER}."

# Publish every additional GeoPackage found in data/sample. The data loader
# creates a table from the file stem and an optional same-named SLD is applied.
for gpkg_path in /data/sample/*.gpkg; do
  [ -f "${gpkg_path}" ] || continue
  [ "${gpkg_path}" != "${DATA_GPKG_PATH}" ] || continue

  file_name="${gpkg_path##*/}"
  file_stem="${file_name%.gpkg}"
  GEOSERVER_LAYER="$(printf '%s' "${file_stem}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g; s/^[0-9]/layer_&/')"
  GEOSERVER_LAYER_TITLE="$(printf '%s' "${file_stem}" | tr '_' ' ')"
  GEOSERVER_STYLE="${file_stem}"
  GEOSERVER_SLD_PATH="/data/sample/${file_stem}.sld"

  publish_featuretype
  if [ -f "${GEOSERVER_SLD_PATH}" ]; then
    publish_style
    assign_style
  else
    echo "Layer ${GEOSERVER_LAYER}: no matching SLD; using GeoServer default style."
  fi
  validate_publication
done
