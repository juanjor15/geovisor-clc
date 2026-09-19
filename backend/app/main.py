import json
import logging
import math
import re
import shutil
import subprocess
import tempfile
from datetime import datetime, timezone
from io import BytesIO
from os import getenv
from pathlib import Path
from typing import Any, Literal
from urllib.parse import urlencode
from urllib.request import urlopen
from xml.sax.saxutils import escape

import psycopg
from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse
from PIL import Image as PILImage, ImageDraw, ImageFont
from reportlab.graphics.charts.piecharts import Pie
from reportlab.graphics.shapes import Drawing, String
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import (
    Image,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)
from starlette.background import BackgroundTask
from psycopg import sql
from psycopg.rows import dict_row
from pydantic import BaseModel, ConfigDict, Field, model_validator


IDENTIFIER_PATTERN = re.compile(r"^[a-zA-Z_][a-zA-Z0-9_]*$")
GEOJSON_GEOMETRY_TYPES = {
    "Point", "MultiPoint", "LineString", "MultiLineString", "Polygon", "MultiPolygon"
}
CLC_COLORS = {
    "111": "#CC0000", "112": "#F80000", "121": "#CC4D2A", "122": "#D96545",
    "123": "#E1846B", "124": "#E79C87", "125": "#EEB9AA", "131": "#A600CC",
    "132": "#D317FF", "141": "#FF8080", "142": "#FFAFAF", "211": "#FFFFA6",
    "212": "#EEE800", "213": "#FFFF5F", "214": "#E1D200", "215": "#D2CD00",
    "221": "#F2CCA6", "222": "#F2A64D", "223": "#E6A600", "224": "#CC900A",
    "225": "#824A12", "231": "#CCFFCC", "232": "#9EFF9E", "233": "#9EFFC8",
    "241": "#FFE6A6", "242": "#FFD875", "243": "#FFC941", "244": "#FEB500",
    "245": "#FFB03C", "311": "#478F00", "312": "#55AB00", "313": "#61C200",
    "314": "#70E000", "315": "#80FF00", "321": "#CCF24E", "322": "#ACDB0F",
    "323": "#96BF0D", "331": "#C2C2C2", "332": "#B3B3B3", "333": "#9E9E9E",
    "334": "#898989", "335": "#6565B4", "411": "#A6A6FF", "412": "#4D91FF",
    "413": "#5050FF", "421": "#CCCCFF", "422": "#B7B7FF", "423": "#A6A6E6",
    "511": "#0000F8", "512": "#0080FF", "513": "#00B2FF", "514": "#00CEF2",
    "521": "#45E0F5", "523": "#CCF6FF",
}
logger = logging.getLogger(__name__)


class GeoJSONResponse(JSONResponse):
    media_type = "application/geo+json"


class SpatialReportRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    result: dict[str, Any]
    bbox: tuple[float, float, float, float]
    query: dict[str, Any] | None = None

    @model_validator(mode="after")
    def validate_report(self) -> "SpatialReportRequest":
        if self.result.get("type") != "FeatureCollection":
            raise ValueError("result must be a GeoJSON FeatureCollection")
        features = self.result.get("features")
        if not isinstance(features, list) or not features:
            raise ValueError("result must contain at least one feature")
        if len(features) > 1000:
            raise ValueError("the report supports up to 1000 features")
        west, south, east, north = self.bbox
        if not (-180 <= west < east <= 180 and -90 <= south < north <= 90):
            raise ValueError("bbox must be a valid EPSG:4326 extent")
        return self


def env_int(name: str, default: int) -> int:
    return int(getenv(name, str(default)))


def require_identifier(value: str, label: str) -> str:
    if not IDENTIFIER_PATTERN.match(value):
        raise RuntimeError(f"Invalid SQL identifier for {label}: {value}")
    return value


def db_config() -> dict[str, Any]:
    return {
        "host": getenv("POSTGRES_HOST", "postgis"),
        "port": env_int("POSTGRES_PORT", 5432),
        "dbname": getenv("POSTGRES_DB", "geovisor"),
        "user": getenv("POSTGRES_USER", "geovisor"),
        "password": getenv("POSTGRES_PASSWORD", "geovisor"),
    }


def db_table() -> tuple[str, str]:
    schema = require_identifier(getenv("POSTGRES_SCHEMA", "gis"), "schema")
    table = require_identifier(getenv("POSTGRES_TABLE", "land_cover"), "table")
    return schema, table


def query_srid() -> int:
    return env_int("DATA_SRID", 9377)


def connect() -> psycopg.Connection:
    return psycopg.connect(**db_config(), row_factory=dict_row)


def ogr_pg_connection() -> str:
    config = db_config()
    return "PG:" + " ".join(
        f"{key}='{str(value).replace(chr(39), chr(92) + chr(39))}'"
        for key, value in config.items()
    )


class PointQuery(BaseModel):
    model_config = ConfigDict(extra="forbid")

    longitude: float = Field(..., ge=-180, le=180)
    latitude: float = Field(..., ge=-90, le=90)


class IntersectionRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    geometry: dict[str, Any] | None = None
    point: PointQuery | None = None
    radius_m: float | None = Field(default=None, gt=0, le=50000)
    buffer_m: float | None = Field(default=None, gt=0, le=50000)
    input_srid: Literal[4326] = 4326

    @property
    def mode(self) -> Literal["geometry", "point", "point_radius"]:
        if self.geometry is not None:
            return "geometry"
        return "point_radius" if self.radius_m is not None else "point"

    @staticmethod
    def validate_geojson_geometry(geometry: dict[str, Any]) -> None:
        geometry_type = geometry.get("type")
        coordinates = geometry.get("coordinates")
        if geometry_type not in GEOJSON_GEOMETRY_TYPES:
            raise ValueError(f"Unsupported GeoJSON geometry type: {geometry_type}")
        if coordinates is None:
            raise ValueError("geometry.coordinates is required")

        def position(value: Any) -> bool:
            return (
                isinstance(value, list)
                and len(value) >= 2
                and all(
                    isinstance(number, (int, float))
                    and not isinstance(number, bool)
                    and math.isfinite(number)
                    for number in value[:2]
                )
            )

        def line(value: Any) -> bool:
            return isinstance(value, list) and len(value) >= 2 and all(position(p) for p in value)

        def ring(value: Any) -> bool:
            return (
                isinstance(value, list)
                and len(value) >= 4
                and all(position(p) for p in value)
                and value[0][:2] == value[-1][:2]
            )

        def polygon(value: Any) -> bool:
            return isinstance(value, list) and len(value) >= 1 and all(ring(r) for r in value)

        valid = {
            "Point": position(coordinates),
            "MultiPoint": isinstance(coordinates, list) and len(coordinates) >= 1 and all(position(p) for p in coordinates),
            "LineString": line(coordinates),
            "MultiLineString": isinstance(coordinates, list) and len(coordinates) >= 1 and all(line(item) for item in coordinates),
            "Polygon": polygon(coordinates),
            "MultiPolygon": isinstance(coordinates, list) and len(coordinates) >= 1 and all(polygon(item) for item in coordinates),
        }[geometry_type]
        if not valid:
            raise ValueError(f"Invalid coordinates for GeoJSON {geometry_type}")

    @model_validator(mode="after")
    def validate_payload(self) -> "IntersectionRequest":
        if self.geometry is not None and self.point is not None:
            raise ValueError("Send geometry or point, not both")

        if self.geometry is not None:
            if self.radius_m is not None:
                raise ValueError("radius_m is only valid with point")
            self.validate_geojson_geometry(self.geometry)
            geometry_type = str(self.geometry["type"])
            linear_types = {"Point", "MultiPoint", "LineString", "MultiLineString"}
            if geometry_type in linear_types and self.buffer_m is None:
                raise ValueError("buffer_m is required for point or line geometries")
            return self

        if self.point is not None:
            if self.buffer_m is not None:
                raise ValueError("buffer_m is only valid with geometry")
            return self

        raise ValueError("Send either geometry or point")


app = FastAPI(
    title="Geovisor CLC API",
    version="0.3.0",
    description="Servicios de consulta espacial para coberturas CLC.",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
)


@app.get("/api/v1/download")
def download_layer(
    format: Literal["geojson", "gpkg", "shapefile"] = Query(default="geojson"),
) -> FileResponse:
    """Export the complete land-cover layer from PostGIS."""
    schema, table = db_table()
    srid = query_srid()
    workdir = Path(tempfile.mkdtemp(prefix="clc_download_"))
    basename = "CLC_2018_Pereira"

    formats = {
        "geojson": {
            "driver": "GeoJSON",
            "path": workdir / f"{basename}.geojson",
            "content_type": "application/geo+json",
            "target_srid": 4326,
            "options": ["-lco", "RFC7946=YES"],
        },
        "gpkg": {
            "driver": "GPKG",
            "path": workdir / f"{basename}.gpkg",
            "content_type": "application/geopackage+sqlite3",
            "target_srid": srid,
            "options": ["-lco", "SPATIAL_INDEX=YES"],
        },
        "shapefile": {
            "driver": "ESRI Shapefile",
            "path": workdir / basename,
            "content_type": "application/zip",
            "target_srid": srid,
            "options": ["-lco", "ENCODING=UTF-8"],
        },
    }
    export = formats[format]
    target_srid = export["target_srid"]
    select_sql = (
        f'SELECT id, codigo, leyenda, nivel_1, nivel_2, nivel_3, nivel_4, '
        f'nivel_5, nivel_6, area_m2, area_ha, '
        f'ST_Transform(geom, {target_srid}) AS geom '
        f'FROM "{schema}"."{table}" ORDER BY id'
    )
    command = [
        "ogr2ogr",
        "-f", export["driver"],
        str(export["path"]),
        ogr_pg_connection(),
        "-sql", select_sql,
        "-nln", "clc_2018_pereira",
        "-nlt", "MULTIPOLYGON",
        "-a_srs", f"EPSG:{target_srid}",
        *export["options"],
    ]

    try:
        subprocess.run(command, check=True, capture_output=True, text=True, timeout=120)
        response_path = export["path"]
        download_name = response_path.name
        if format == "shapefile":
            archive = shutil.make_archive(
                str(workdir / basename), "zip", root_dir=export["path"]
            )
            response_path = Path(archive)
            download_name = response_path.name
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired, OSError) as exc:
        shutil.rmtree(workdir, ignore_errors=True)
        detail = getattr(exc, "stderr", None) or str(exc)
        raise HTTPException(
            status_code=500,
            detail={"status": "error", "message": f"No fue posible exportar la capa: {detail}"},
        ) from exc

    return FileResponse(
        path=response_path,
        media_type=export["content_type"],
        filename=download_name,
        background=BackgroundTask(shutil.rmtree, workdir, ignore_errors=True),
    )


@app.get("/api/v1/health")
def health() -> dict[str, Any]:
    schema, table = db_table()
    statement = sql.SQL(
        """
        SELECT
            1 AS db_ok,
            postgis_version() AS postgis_version,
            (
                SELECT count(*)
                FROM {}.{}
            ) AS feature_count
        """
    ).format(sql.Identifier(schema), sql.Identifier(table))

    try:
        with connect() as conn:
            row = conn.execute(statement).fetchone()
    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail={"status": "error", "database": "unavailable", "message": str(exc)},
        ) from exc

    return {
        "status": "ok",
        "service": "backend",
        "environment": getenv("APP_ENV", "local"),
        "database": {
            "connected": True,
            "host": getenv("POSTGRES_HOST", "postgis"),
            "port": env_int("POSTGRES_PORT", 5432),
            "name": getenv("POSTGRES_DB", "geovisor"),
            "schema": schema,
            "table": table,
            "postgis_version": row["postgis_version"],
            "feature_count": row["feature_count"],
        },
        "data": {
            "layer": getenv("DATA_GPKG_LAYER", "clc_2018_pereira"),
            "srid": query_srid(),
        },
    }


@app.get("/api/v1/metadata")
def metadata() -> dict[str, Any]:
    return {
        "dataset": "Coberturas de la Tierra CLC 2018",
        "source": "Colombia en Mapas",
        "area_of_interest": "Pereira, Risaralda",
        "analysis_srid": "EPSG:9377",
        "geopackage_layer": getenv("DATA_GPKG_LAYER", "clc_2018_pereira"),
        "geoserver": {
            "workspace": getenv("GEOSERVER_WORKSPACE", "clc"),
            "datastore": getenv("GEOSERVER_DATASTORE", "postgis"),
            "layer": getenv("GEOSERVER_LAYER", "land_cover"),
            "style": getenv("GEOSERVER_STYLE", "CLC_2018"),
        },
    }


@app.get("/api/v1/layers")
def layers() -> dict[str, Any]:
    """Return the layers discovered from GeoPackages in data/sample."""
    schema, _ = db_table()
    workspace = getenv("GEOSERVER_WORKSPACE", "clc")
    try:
        with connect() as connection, connection.cursor() as cursor:
            cursor.execute(
                sql.SQL(
                    """
                    SELECT layer_name, title, style_name, source_file, is_primary
                    FROM {}.layer_catalog
                    ORDER BY is_primary DESC, title
                    """
                ).format(sql.Identifier(schema))
            )
            rows = cursor.fetchall()
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Layer catalog is unavailable") from exc

    return {
        "workspace": workspace,
        "layers": [
            {
                **row,
                "qualified_name": f"{workspace}:{row['layer_name']}",
            }
            for row in rows
        ],
    }


@app.get("/api/v1/statistics")
@app.post("/api/v1/statistics")
def statistics() -> dict[str, Any]:
    schema, table = db_table()
    statement = sql.SQL(
        """
        WITH coverage AS (
            SELECT
                codigo,
                leyenda,
                nivel_1,
                nivel_2,
                nivel_3,
                nivel_4,
                nivel_5,
                nivel_6,
                SUM(area_m2) AS area_m2,
                SUM(area_ha) AS area_ha
            FROM {}.{}
            GROUP BY codigo, leyenda, nivel_1, nivel_2, nivel_3, nivel_4, nivel_5, nivel_6
        ),
        totals AS (
            SELECT SUM(area_m2) AS total_area_m2, SUM(area_ha) AS total_area_ha
            FROM coverage
        )
        SELECT
            coverage.codigo,
            coverage.leyenda,
            coverage.nivel_1,
            coverage.nivel_2,
            coverage.nivel_3,
            coverage.nivel_4,
            coverage.nivel_5,
            coverage.nivel_6,
            ROUND(coverage.area_m2::numeric, 2)::float AS area_m2,
            ROUND(coverage.area_ha::numeric, 4)::float AS area_ha,
            ROUND((coverage.area_m2 / NULLIF(totals.total_area_m2, 0) * 100)::numeric, 4)::float AS percentage
        FROM coverage
        CROSS JOIN totals
        ORDER BY coverage.area_ha DESC, coverage.leyenda
        """
    ).format(sql.Identifier(schema), sql.Identifier(table))

    with connect() as conn:
        rows = conn.execute(statement).fetchall()

    total_area_ha = round(sum(row["area_ha"] for row in rows), 4)
    return {
        "type": "coverage_statistics",
        "srid": query_srid(),
        "total_area_ha": total_area_ha,
        "count": len(rows),
        "items": rows,
    }


def report_summaries(features: list[dict[str, Any]]) -> list[dict[str, Any]]:
    grouped: dict[tuple[str, str], dict[str, Any]] = {}
    for feature in features:
        properties = feature.get("properties") or {}
        code = str(properties.get("codigo") or "")
        label = str(properties.get("leyenda") or "Sin clasificación")
        key = (code, label)
        item = grouped.setdefault(
            key,
            {
                "code": code,
                "label": label,
                "level_one": str(properties.get("nivel_1") or "N/D"),
                "area_ha": 0.0,
            },
        )
        item["area_ha"] += float(properties.get("area_ha") or 0)

    items = sorted(grouped.values(), key=lambda item: item["area_ha"], reverse=True)
    total = sum(item["area_ha"] for item in items)
    for item in items:
        item["percentage"] = item["area_ha"] / total * 100 if total else 0.0
    return items


def format_distance(distance_m: float) -> str:
    if distance_m >= 1000:
        return f"{distance_m / 1000:,.3f} km ({distance_m:,.0f} m)"
    return f"{distance_m:,.2f} m"


def query_report_rows(query: dict[str, Any] | None) -> list[list[str]]:
    if not query:
        return [["Parámetros", "No disponibles"]]
    input_srid = int(query.get("input_srid") or 4326)
    rows: list[list[str]] = [["CRS de entrada", f"EPSG:{input_srid}"]]
    point = query.get("point") or {}
    if point.get("longitude") is not None and point.get("latitude") is not None:
        longitude = float(point["longitude"])
        latitude = float(point["latitude"])
        rows.extend(
            [
                ["Tipo de consulta", "Punto con radio" if query.get("radius_m") else "Identificación por punto"],
                ["Coordenada", f"Longitud {longitude:.6f} · Latitud {latitude:.6f}"],
            ]
        )
        if query.get("radius_m"):
            rows.append(["Radio del buffer", format_distance(float(query["radius_m"]))])
            rows.append(["Diámetro del buffer", format_distance(float(query["radius_m"]) * 2)])
        return rows

    geometry = query.get("geometry") or {}
    geometry_type = str(geometry.get("type") or "Geometría")
    coordinates: list[tuple[float, float]] = []

    def collect(value: Any) -> None:
        if (
            isinstance(value, (list, tuple))
            and len(value) >= 2
            and isinstance(value[0], (int, float))
            and isinstance(value[1], (int, float))
        ):
            coordinates.append((float(value[0]), float(value[1])))
        elif isinstance(value, (list, tuple)):
            for item in value:
                collect(item)

    collect(geometry.get("coordinates"))
    labels = {
        "Point": "Punto",
        "MultiPoint": "Multipunto",
        "LineString": "Línea",
        "MultiLineString": "Multilínea",
        "Polygon": "Polígono / área de interés",
        "MultiPolygon": "Multipolígono / área de interés",
    }
    rows.append(["Tipo de consulta", labels.get(geometry_type, geometry_type)])
    rows.append(["Vértices enviados", str(len(coordinates))])
    if coordinates:
        first = coordinates[0]
        last = coordinates[-1]
        rows.append(["Coordenada inicial", f"Longitud {first[0]:.6f} · Latitud {first[1]:.6f}"])
        if last != first:
            rows.append(["Coordenada final", f"Longitud {last[0]:.6f} · Latitud {last[1]:.6f}"])
        west = min(coordinate[0] for coordinate in coordinates)
        south = min(coordinate[1] for coordinate in coordinates)
        east = max(coordinate[0] for coordinate in coordinates)
        north = max(coordinate[1] for coordinate in coordinates)
        rows.append(["Extensión de consulta", f"O {west:.6f} · S {south:.6f} · E {east:.6f} · N {north:.6f}"])
    if query.get("buffer_m"):
        rows.append(["Distancia del buffer", format_distance(float(query["buffer_m"]))])
        rows.append(["Ancho total del corredor", format_distance(float(query["buffer_m"]) * 2)])
    return rows


def expanded_bbox(
    bbox: tuple[float, float, float, float], target_ratio: float, padding: float = 0.14
) -> tuple[float, float, float, float]:
    west, south, east, north = bbox
    center_x = (west + east) / 2
    center_y = (south + north) / 2
    width = (east - west) * (1 + padding * 2)
    height = (north - south) * (1 + padding * 2)
    if width / height < target_ratio:
        width = height * target_ratio
    else:
        height = width / target_ratio
    return (
        max(-180.0, center_x - width / 2),
        max(-90.0, center_y - height / 2),
        min(180.0, center_x + width / 2),
        min(90.0, center_y + height / 2),
    )


def nice_scale_distance(distance_m: float) -> float:
    if distance_m <= 0:
        return 1.0
    magnitude = 10 ** math.floor(math.log10(distance_m))
    normalized = distance_m / magnitude
    step = 1 if normalized < 2 else 2 if normalized < 5 else 5
    return step * magnitude


def bbox_with_query(
    bbox: tuple[float, float, float, float], query: dict[str, Any] | None
) -> tuple[float, float, float, float]:
    if not query or int(query.get("input_srid") or 4326) != 4326:
        return bbox
    coordinates: list[tuple[float, float]] = []

    def collect(value: Any) -> None:
        if (
            isinstance(value, (list, tuple))
            and len(value) >= 2
            and isinstance(value[0], (int, float))
            and isinstance(value[1], (int, float))
        ):
            coordinates.append((float(value[0]), float(value[1])))
        elif isinstance(value, (list, tuple)):
            for item in value:
                collect(item)

    geometry = query.get("geometry") or {}
    collect(geometry.get("coordinates"))
    point = query.get("point") or {}
    if point.get("longitude") is not None and point.get("latitude") is not None:
        coordinates.append((float(point["longitude"]), float(point["latitude"])))
    if not coordinates:
        return bbox

    west, south, east, north = bbox
    west = min(west, *(coordinate[0] for coordinate in coordinates))
    south = min(south, *(coordinate[1] for coordinate in coordinates))
    east = max(east, *(coordinate[0] for coordinate in coordinates))
    north = max(north, *(coordinate[1] for coordinate in coordinates))
    radius_m = float(query.get("radius_m") or query.get("buffer_m") or 0)
    if radius_m > 0:
        center_lat = sum(coordinate[1] for coordinate in coordinates) / len(coordinates)
        latitude_margin = radius_m / 111320
        longitude_margin = latitude_margin / max(math.cos(math.radians(center_lat)), 0.01)
        west -= longitude_margin
        east += longitude_margin
        south -= latitude_margin
        north += latitude_margin
    return west, south, east, north


def map_pixel(
    coordinate: list[float] | tuple[float, float],
    bbox: tuple[float, float, float, float],
    width: int,
    height: int,
) -> tuple[int, int]:
    west, south, east, north = bbox
    longitude, latitude = coordinate[:2]
    x = round((longitude - west) / (east - west) * width)
    y = round((north - latitude) / (north - south) * height)
    return x, y


def draw_query_boundary(
    image: PILImage.Image,
    bbox: tuple[float, float, float, float],
    query: dict[str, Any] | None,
) -> None:
    if not query:
        return
    width, height = image.size
    overlay = PILImage.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    outline = (8, 31, 45, 255)
    halo = (251, 229, 80, 255)
    fill = (251, 229, 80, 52)

    geometry = query.get("geometry")
    point = query.get("point")
    radius_m = float(query.get("radius_m") or query.get("buffer_m") or 0)
    if point:
        geometry = {
            "type": "Point",
            "coordinates": [point.get("longitude"), point.get("latitude")],
        }

    if not isinstance(geometry, dict):
        return
    geometry_type = geometry.get("type")
    coordinates = geometry.get("coordinates")
    if not coordinates:
        return

    def line(points: list[list[float]], buffered: bool = False) -> None:
        pixels = [map_pixel(point_value, bbox, width, height) for point_value in points]
        if len(pixels) < 2:
            return
        if buffered and radius_m > 0:
            center_lat = (bbox[1] + bbox[3]) / 2
            map_width_m = (bbox[2] - bbox[0]) * 111320 * math.cos(math.radians(center_lat))
            buffer_px = max(5, round(radius_m / map_width_m * width * 2)) if map_width_m else 8
            draw.line(pixels, fill=fill, width=buffer_px, joint="curve")
        draw.line(pixels, fill=halo, width=8, joint="curve")
        draw.line(pixels, fill=outline, width=4, joint="curve")

    if geometry_type == "Point":
        x, y = map_pixel(coordinates, bbox, width, height)
        radius_px = 0
        if radius_m > 0:
            center_lat = (bbox[1] + bbox[3]) / 2
            map_width_m = (bbox[2] - bbox[0]) * 111320 * math.cos(math.radians(center_lat))
            radius_px = max(7, round(radius_m / map_width_m * width)) if map_width_m else 10
            draw.ellipse((x - radius_px, y - radius_px, x + radius_px, y + radius_px), fill=fill, outline=halo, width=8)
            draw.ellipse((x - radius_px, y - radius_px, x + radius_px, y + radius_px), outline=outline, width=4)
        marker_radius = 8
        draw.ellipse((x - marker_radius, y - marker_radius, x + marker_radius, y + marker_radius), fill=halo, outline=outline, width=3)
    elif geometry_type == "LineString":
        line(coordinates, buffered=True)
    elif geometry_type == "MultiLineString":
        for item in coordinates:
            line(item, buffered=True)
    elif geometry_type == "Polygon":
        for index, ring in enumerate(coordinates):
            pixels = [map_pixel(point_value, bbox, width, height) for point_value in ring]
            if index == 0:
                draw.polygon(pixels, fill=fill)
            draw.line(pixels, fill=halo, width=8, joint="curve")
            draw.line(pixels, fill=outline, width=4, joint="curve")
    elif geometry_type == "MultiPolygon":
        for polygon in coordinates:
            for index, ring in enumerate(polygon):
                pixels = [map_pixel(point_value, bbox, width, height) for point_value in ring]
                if index == 0:
                    draw.polygon(pixels, fill=fill)
                draw.line(pixels, fill=halo, width=8, joint="curve")
                draw.line(pixels, fill=outline, width=4, joint="curve")

    image.paste(overlay, (0, 0), overlay)


def decorate_report_map(
    image_buffer: BytesIO,
    bbox: tuple[float, float, float, float],
    query: dict[str, Any] | None,
) -> BytesIO:
    image = PILImage.open(image_buffer).convert("RGB")
    width, height = image.size
    draw_query_boundary(image, bbox, query)
    draw = ImageDraw.Draw(image)
    font = ImageFont.load_default()
    bold_font = ImageFont.load_default(size=15)

    draw.rectangle((0, 0, width - 1, height - 1), outline="#081F2D", width=4)
    draw.rounded_rectangle((18, 16, 292, 52), radius=7, fill="white", outline="#C9DFE4", width=2)
    draw.text((32, 26), "Coberturas CLC 2018 - Pereira", fill="#081F2D", font=bold_font)
    if query:
        draw.rounded_rectangle((18, 60, 190, 94), radius=7, fill="white", outline="#C9DFE4", width=2)
        draw.line((31, 77, 64, 77), fill="#FBE550", width=8)
        draw.line((31, 77, 64, 77), fill="#081F2D", width=4)
        draw.text((74, 70), "Limite de consulta", fill="#081F2D", font=font)

    north_x, north_y = width - 50, 62
    draw.rounded_rectangle((north_x - 28, 16, north_x + 28, 94), radius=7, fill="white", outline="#C9DFE4", width=2)
    draw.polygon(
        [(north_x, north_y - 26), (north_x - 10, north_y + 8), (north_x, north_y + 2), (north_x + 10, north_y + 8)],
        fill="#081F2D",
    )
    draw.text((north_x - 4, north_y + 10), "N", fill="#081F2D", font=bold_font)

    west, south, east, north = bbox
    center_lat = (south + north) / 2
    map_width_m = (east - west) * 111320 * math.cos(math.radians(center_lat))
    scale_m = nice_scale_distance(map_width_m / 5)
    scale_px = max(45, round(width * scale_m / map_width_m)) if map_width_m else 80
    x0, y0 = 34, height - 38
    draw.rounded_rectangle((18, height - 66, x0 + scale_px + 22, height - 14), radius=7, fill="white", outline="#C9DFE4", width=2)
    draw.line((x0, y0, x0 + scale_px, y0), fill="#081F2D", width=5)
    draw.line((x0, y0 - 6, x0, y0 + 6), fill="#081F2D", width=3)
    draw.line((x0 + scale_px, y0 - 6, x0 + scale_px, y0 + 6), fill="#081F2D", width=3)
    scale_label = f"{scale_m / 1000:g} km" if scale_m >= 1000 else f"{scale_m:g} m"
    draw.text((x0, y0 - 22), scale_label, fill="#081F2D", font=font)

    output = BytesIO()
    image.save(output, format="PNG", optimize=True)
    output.seek(0)
    return output


def report_map_image(
    bbox: tuple[float, float, float, float], query: dict[str, Any] | None
) -> tuple[BytesIO, tuple[float, float, float, float]]:
    workspace = getenv("GEOSERVER_WORKSPACE", "clc")
    layer = getenv("GEOSERVER_LAYER", "land_cover")
    style = getenv("GEOSERVER_STYLE", "CLC_2018")
    geoserver_url = getenv("GEOSERVER_URL", "http://geoserver:8080/geoserver").rstrip("/")
    map_width = 1200
    map_height = 560
    display_bbox = expanded_bbox(bbox_with_query(bbox, query), map_width / map_height)
    params = urlencode(
        {
            "service": "WMS",
            "version": "1.1.1",
            "request": "GetMap",
            "layers": f"{workspace}:{layer}",
            "styles": style,
            "srs": "EPSG:4326",
            "bbox": ",".join(str(value) for value in display_bbox),
            "width": map_width,
            "height": map_height,
            "format": "image/png",
            "transparent": "false",
            "bgcolor": "0xF4FAFB",
        }
    )
    with urlopen(f"{geoserver_url}/{workspace}/wms?{params}", timeout=20) as response:
        content_type = response.headers.get("Content-Type", "")
        if response.status != 200 or "image/png" not in content_type:
            raise RuntimeError("GeoServer did not return a PNG map")
        return decorate_report_map(BytesIO(response.read()), display_bbox, query), display_bbox


@app.post("/api/v1/reports/spatial-query.pdf")
def spatial_query_report(payload: SpatialReportRequest) -> StreamingResponse:
    features = payload.result["features"]
    summaries = report_summaries(features)
    metadata = payload.result.get("metadata") or {}
    output = BytesIO()
    page_width, _ = landscape(A4)
    document = SimpleDocTemplate(
        output,
        pagesize=landscape(A4),
        rightMargin=1.35 * cm,
        leftMargin=1.35 * cm,
        topMargin=1.2 * cm,
        bottomMargin=1.2 * cm,
        title="Informe de consulta espacial CLC 2018",
        author="Geovisor CLC Pereira",
    )
    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="ReportTitle",
            parent=styles["Title"],
            fontName="Helvetica-Bold",
            fontSize=18,
            leading=22,
            alignment=TA_CENTER,
            textColor=colors.HexColor("#081F2D"),
            spaceAfter=8,
        )
    )
    body = styles["BodyText"]
    body.fontName = "Helvetica"
    body.fontSize = 9
    body.leading = 12
    story: list[Any] = [
        Paragraph("Informe de consulta espacial CLC 2018", styles["ReportTitle"]),
        Paragraph(
            "Pereira, Risaralda · Generado el "
            + datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
            ParagraphStyle("Subtitle", parent=body, alignment=TA_CENTER, textColor=colors.HexColor("#526B76")),
        ),
        Spacer(1, 0.3 * cm),
    ]

    metric_data = [
        ["Tipo de consulta", "Coberturas", "Área interceptada", "CRS de salida"],
        [
            escape(str(metadata.get("query_type", "consulta espacial"))),
            str(len(summaries)),
            f"{float(metadata.get('total_area_ha') or 0):,.4f} ha",
            "EPSG:4326",
        ],
    ]
    metrics = Table(metric_data, colWidths=[6.1 * cm, 4.2 * cm, 5.2 * cm, 4.2 * cm])
    metrics.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#081F2D")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTNAME", (0, 1), (-1, 1), "Helvetica"),
                ("ALIGN", (1, 0), (-1, -1), "CENTER"),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#C9DFE4")),
                ("BACKGROUND", (0, 1), (-1, 1), colors.HexColor("#F4FAFB")),
                ("TOPPADDING", (0, 0), (-1, -1), 6),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ]
        )
    )
    story.extend([metrics, Spacer(1, 0.28 * cm)])

    parameter_rows = query_report_rows(payload.query)
    parameter_data: list[list[Any]] = [["Parámetro", "Valor"]]
    parameter_data.extend(
        [[Paragraph(escape(name), body), Paragraph(escape(value), body)] for name, value in parameter_rows]
    )
    parameter_table = Table(parameter_data, repeatRows=1, colWidths=[5.2 * cm, 15.6 * cm])
    parameter_table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#95CAD6")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#081F2D")),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTNAME", (0, 1), (0, -1), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#C9DFE4")),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F4FAFB")]),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ]
        )
    )
    coordinate_note = Paragraph(
        "Las coordenadas se presentan en orden longitud, latitud. La distancia del buffer se mide desde el eje o punto hacia cada lado.",
        ParagraphStyle("CoordinateNote", parent=body, fontSize=8, textColor=colors.HexColor("#526B76")),
    )
    story.extend(
        [
            Paragraph("Parámetros de la consulta", styles["Heading2"]),
            parameter_table,
            Spacer(1, 0.08 * cm),
            coordinate_note,
            Spacer(1, 0.35 * cm),
        ]
    )

    try:
        map_buffer, display_bbox = report_map_image(payload.bbox, payload.query)
        map_width = page_width - 2.7 * cm
        map_image = Image(map_buffer, width=map_width, height=map_width * 560 / 1200)
        bbox_caption = (
            f"Extension ampliada: {display_bbox[0]:.5f}, {display_bbox[1]:.5f}, "
            f"{display_bbox[2]:.5f}, {display_bbox[3]:.5f} (EPSG:4326)"
        )
        story.extend([
            Paragraph("Mapa de la consulta", styles["Heading2"]),
            map_image,
            Paragraph(bbox_caption, ParagraphStyle("MapCaption", parent=body, alignment=TA_CENTER, textColor=colors.HexColor("#526B76"))),
        ])
    except Exception:
        logger.exception("Could not fetch the WMS map for the PDF report")
        story.append(Paragraph("No fue posible incorporar la imagen WMS del mapa.", body))

    story.extend([Spacer(1, 0.35 * cm), Paragraph("Distribución de coberturas", styles["Heading2"])])
    chart_items = summaries[:9]
    if len(summaries) > 9:
        other_area = sum(item["area_ha"] for item in summaries[9:])
        other_percentage = sum(item["percentage"] for item in summaries[9:])
        chart_items.append(
            {
                "code": "",
                "label": f"Otras coberturas ({len(summaries) - 9})",
                "area_ha": other_area,
                "percentage": other_percentage,
            }
        )
    drawing = Drawing(750, 190)
    pie = Pie()
    pie.x = 15
    pie.y = 15
    pie.width = 155
    pie.height = 155
    pie.data = [item["area_ha"] for item in chart_items]
    pie.labels = None
    chart_colors = [CLC_COLORS.get(str(item["code"])[:3], "#8B9690") for item in chart_items]
    for index, color in enumerate(chart_colors):
        pie.slices[index].fillColor = colors.HexColor(color)
        pie.slices[index].strokeColor = colors.white
    drawing.add(pie)
    for index, item in enumerate(chart_items):
        y = 166 - index * 16
        drawing.add(String(205, y, "■", fontName="Helvetica", fontSize=9, fillColor=colors.HexColor(chart_colors[index])))
        label = item["label"][:66] + ("…" if len(item["label"]) > 66 else "")
        drawing.add(String(220, y, f"{label} — {item['percentage']:.2f}%", fontName="Helvetica", fontSize=8))
    story.append(drawing)

    table_data: list[list[Any]] = [["Código", "Cobertura", "Nivel 1", "Área (ha)", "% resultado"]]
    for item in summaries:
        table_data.append(
            [
                escape(item["code"]),
                Paragraph(escape(item["label"]), body),
                Paragraph(escape(item["level_one"]), body),
                f"{item['area_ha']:,.4f}",
                f"{item['percentage']:.2f}%",
            ]
        )
    result_table = Table(table_data, repeatRows=1, colWidths=[2.2 * cm, 9.2 * cm, 7.2 * cm, 3.2 * cm, 3.2 * cm])
    result_table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#081F2D")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTNAME", (0, 1), (-1, -1), "Helvetica"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
                ("ALIGN", (0, 0), (0, -1), "CENTER"),
                ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#C9DFE4")),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F4FAFB")]),
                ("TOPPADDING", (0, 0), (-1, -1), 5),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
            ]
        )
    )
    story.extend([Paragraph("Tabla de coberturas interceptadas", styles["Heading2"]), result_table])
    document.build(story)
    output.seek(0)
    filename = "informe_consulta_espacial_clc.pdf"
    return StreamingResponse(
        output,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )


@app.post("/api/v1/intersections", response_class=GeoJSONResponse)
def intersections(payload: IntersectionRequest) -> dict[str, Any]:
    schema, table = db_table()
    srid = query_srid()

    if payload.mode == "point":
        statement = sql.SQL(
            """
            WITH click AS (
                SELECT ST_Transform(ST_SetSRID(ST_MakePoint(%s, %s), %s), %s) AS geom
            )
            SELECT
                lc.id,
                lc.codigo,
                lc.leyenda,
                lc.nivel_1,
                lc.nivel_2,
                lc.nivel_3,
                lc.nivel_4,
                lc.nivel_5,
                lc.nivel_6,
                ROUND(ST_Area(lc.geom)::numeric, 2)::float AS area_m2,
                ROUND((ST_Area(lc.geom) / 10000.0)::numeric, 4)::float AS area_ha,
                100.0 AS percentage_of_query,
                ST_AsGeoJSON(ST_Transform(lc.geom, 4326))::json AS geometry
            FROM {}.{} AS lc
            CROSS JOIN click
            WHERE ST_Covers(lc.geom, click.geom)
            ORDER BY ST_Area(lc.geom) ASC
            LIMIT 1
            """
        ).format(sql.Identifier(schema), sql.Identifier(table))
        params = [
            payload.point.longitude,  # type: ignore[union-attr]
            payload.point.latitude,  # type: ignore[union-attr]
            payload.input_srid,
            srid,
        ]

        try:
            with connect() as conn:
                rows = conn.execute(statement, params).fetchall()
        except Exception as exc:
            logger.exception("Direct point intersection failed")
            raise HTTPException(
                status_code=400,
                detail={"status": "error", "message": "No fue posible procesar la consulta espacial."},
            ) from exc

        features = [
            {
                "type": "Feature",
                "geometry": row["geometry"],
                "properties": {key: row[key] for key in (
                    "id", "codigo", "leyenda", "nivel_1", "nivel_2", "nivel_3",
                    "nivel_4", "nivel_5", "nivel_6", "area_m2", "area_ha",
                    "percentage_of_query",
                )},
            }
            for row in rows
        ]
        return {
            "type": "FeatureCollection",
            "metadata": {
                "query_type": "point",
                "analysis_srid": srid,
                "output_srid": 4326,
                "feature_count": len(features),
                "total_area_ha": round(sum(row["area_ha"] for row in rows), 4),
            },
            "features": features,
        }

    if payload.mode == "geometry":
        base_geom = "ST_Transform(ST_SetSRID(ST_GeomFromGeoJSON(%s), %s), %s)"
        params: list[Any] = [json.dumps(payload.geometry), payload.input_srid, srid]
        geometry_type = str(payload.geometry["type"])  # type: ignore[index]

        if payload.buffer_m is not None:
            query_geom = sql.SQL(f"ST_MakeValid(ST_Buffer({base_geom}, %s))")
            params.append(payload.buffer_m)
            query_type = f"{geometry_type.lower()}_buffer"
        else:
            query_geom = sql.SQL(f"ST_MakeValid({base_geom})")
            query_type = "geometry"
    else:
        query_geom = sql.SQL(
            "ST_Buffer(ST_Transform(ST_SetSRID(ST_MakePoint(%s, %s), %s), %s), %s, 'quad_segs=32')"
        )
        params = [
            payload.point.longitude,  # type: ignore[union-attr]
            payload.point.latitude,  # type: ignore[union-attr]
            payload.input_srid,
            srid,
            payload.radius_m,
        ]
        query_type = "point_radius"

    statement = sql.SQL(
        """
        WITH query AS (
            SELECT {query_geom}::geometry AS geom
        ),
        raw_intersections AS (
            SELECT
                lc.id,
                lc.codigo,
                lc.leyenda,
                lc.nivel_1,
                lc.nivel_2,
                lc.nivel_3,
                lc.nivel_4,
                lc.nivel_5,
                lc.nivel_6,
                ST_Multi(
                    ST_CollectionExtract(
                        ST_Intersection(ST_MakeValid(lc.geom), query.geom),
                        3
                    )
                )::geometry(MultiPolygon, {srid}) AS geom
            FROM {}.{} AS lc
            CROSS JOIN query
            WHERE ST_Intersects(lc.geom, query.geom)
        ),
        filtered AS (
            SELECT
                *,
                ST_Area(geom) AS area_m2
            FROM raw_intersections
            WHERE NOT ST_IsEmpty(geom)
        ),
        query_area AS (
            SELECT ST_Area(geom) AS area_m2
            FROM query
        )
        SELECT
            filtered.id,
            filtered.codigo,
            filtered.leyenda,
            filtered.nivel_1,
            filtered.nivel_2,
            filtered.nivel_3,
            filtered.nivel_4,
            filtered.nivel_5,
            filtered.nivel_6,
            ROUND(filtered.area_m2::numeric, 2)::float AS area_m2,
            ROUND((filtered.area_m2 / 10000.0)::numeric, 4)::float AS area_ha,
            ROUND((SUM(filtered.area_m2) OVER () / 10000.0)::numeric, 4)::float AS total_area_ha,
            ROUND((filtered.area_m2 / NULLIF(query_area.area_m2, 0) * 100)::numeric, 4)::float AS percentage_of_query,
            ST_AsGeoJSON(ST_Transform(filtered.geom, 4326))::json AS geometry
        FROM filtered
        CROSS JOIN query_area
        ORDER BY area_ha DESC, leyenda
        """
    ).format(
        sql.Identifier(schema),
        sql.Identifier(table),
        query_geom=query_geom,
        srid=sql.Literal(srid),
    )

    try:
        with connect() as conn:
            rows = conn.execute(statement, params).fetchall()
    except Exception as exc:
        logger.exception("Spatial intersection failed")
        raise HTTPException(
            status_code=400,
            detail={"status": "error", "message": "No fue posible procesar la consulta espacial."},
        ) from exc

    features = []
    for row in rows:
        features.append(
            {
                "type": "Feature",
                "geometry": row["geometry"],
                "properties": {
                    "id": row["id"],
                    "codigo": row["codigo"],
                    "leyenda": row["leyenda"],
                    "nivel_1": row["nivel_1"],
                    "nivel_2": row["nivel_2"],
                    "nivel_3": row["nivel_3"],
                    "nivel_4": row["nivel_4"],
                    "nivel_5": row["nivel_5"],
                    "nivel_6": row["nivel_6"],
                    "area_m2": row["area_m2"],
                    "area_ha": row["area_ha"],
                    "percentage_of_query": row["percentage_of_query"],
                },
            }
        )

    return {
        "type": "FeatureCollection",
        "metadata": {
            "query_type": query_type,
            "analysis_srid": srid,
            "output_srid": 4326,
            "feature_count": len(features),
            "total_area_ha": rows[0]["total_area_ha"] if rows else 0.0,
        },
        "features": features,
    }
