# Metadata de Datos

## Fuente

Coberturas de la Tierra metodologia CORINE Land Cover adaptada para Colombia, descargadas desde [Colombia en Mapas](https://www.colombiaenmapas.gov.co/), plataforma del Instituto Geografico Agustin Codazzi (IGAC).

Cada conjunto de datos publicado en el portal puede tener una licencia de uso propia. La reutilizacion de la muestra incluida en este repositorio debe respetar las condiciones indicadas por la entidad productora y los [terminos y condiciones de Colombia en Mapas](https://www.colombiaenmapas.gov.co/colombia-mapas/terminos-y-condiciones/index.html).

## Muestra

- Area de interes: municipio de Pereira, Risaralda.
- Criterio de seleccion: recorte municipal de la capa CLC 2018.
- Archivo preparado: `data/sample/CLC_2018.gpkg`.
- Capa GeoPackage: `clc_2018_pereira`.
- Geometria: `MULTIPOLYGON`.
- SRID original: `GCS_MAGNA`.
- SRID de analisis: `EPSG:9377` MAGNA-SIRGAS 2018 / Origen-Nacional.
- Estilo GeoServer: `data/sample/CLC_2018.sld`.
- Fecha de preparacion: 19 de septiembre de 2026.

## Transformaciones

- Recorte espacial al municipio de Pereira.
- Reproyeccion desde `GCS_MAGNA` a `EPSG:9377`.
- Exportacion a GeoPackage para carga reproducible en PostGIS.
- Estilo cartografico extraido y convertido a SLD en QGIS usando el complemento SLYR.
