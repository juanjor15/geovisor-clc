#!/usr/bin/env python3
"""Integration checks for the spatial intersection endpoint."""

import json
import os
import sys
from math import isclose
from urllib.error import HTTPError
from urllib.request import Request, urlopen


BASE_URL = os.getenv("GEOVISOR_BASE_URL", "http://localhost:8080").rstrip("/")
ENDPOINT = f"{BASE_URL}/api/v1/intersections"


def post(payload: dict, expected_status: int = 200) -> tuple[dict, str]:
    request = Request(
        ENDPOINT,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urlopen(request, timeout=30) as response:
            status = response.status
            content_type = response.headers.get_content_type()
            body = json.load(response)
    except HTTPError as exc:
        status = exc.code
        content_type = exc.headers.get_content_type()
        body = json.load(exc)

    assert status == expected_status, f"Expected HTTP {expected_status}, got {status}: {body}"
    return body, content_type


def assert_feature_collection(body: dict, content_type: str) -> None:
    assert content_type == "application/geo+json", content_type
    assert body["type"] == "FeatureCollection"
    assert isinstance(body["features"], list)
    assert body["metadata"]["output_srid"] == 4326
    assert body["metadata"]["analysis_srid"] == 9377
    assert body["metadata"]["feature_count"] == len(body["features"])
    summed_area = sum(feature["properties"]["area_ha"] for feature in body["features"])
    assert isclose(summed_area, body["metadata"]["total_area_ha"], abs_tol=0.001)


def main() -> int:
    point, content_type = post({
        "point": {"longitude": -75.65559899726748, "latitude": 4.784582965492272},
        "radius_m": 1000,
        "input_srid": 4326,
    })
    assert_feature_collection(point, content_type)
    assert point["metadata"]["query_type"] == "point_radius"
    assert point["metadata"]["feature_count"] > 0

    polygon, content_type = post({
        "geometry": {
            "type": "Polygon",
            "coordinates": [[
                [-75.665, 4.775], [-75.645, 4.775], [-75.645, 4.795],
                [-75.665, 4.795], [-75.665, 4.775],
            ]],
        },
        "input_srid": 4326,
    })
    assert_feature_collection(polygon, content_type)
    assert polygon["metadata"]["query_type"] == "geometry"
    assert polygon["metadata"]["feature_count"] > 0

    empty, content_type = post({
        "point": {"longitude": -74.0, "latitude": 4.0},
        "radius_m": 1000,
        "input_srid": 4326,
    })
    assert_feature_collection(empty, content_type)
    assert empty["features"] == []
    assert empty["metadata"]["total_area_ha"] == 0

    invalid_cases = [
        {},
        {"geometry": {"type": "Banana", "coordinates": []}},
        {"geometry": {"type": "LineString", "coordinates": [[-75.7, 4.78], [-75.64, 4.82]]}},
        {"geometry": {"type": "Polygon", "coordinates": [[[0, 0], [1, 0], [1, 1], [0, 1]]]}},
        {
            "point": {"longitude": -75.65, "latitude": 4.78},
            "geometry": {"type": "Point", "coordinates": [-75.65, 4.78]},
            "buffer_m": 10,
        },
    ]
    for payload in invalid_cases:
        body, _ = post(payload, expected_status=422)
        assert "detail" in body

    print("OK: point/radius, polygon AOI, empty result, GeoJSON MIME and invalid inputs")
    return 0


if __name__ == "__main__":
    sys.exit(main())
