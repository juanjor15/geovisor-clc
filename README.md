# Geovisor CLC Colombia

Solucion geoespacial dockerizada para consulta, analisis y publicacion OGC de coberturas de la tierra CORINE Land Cover 2018 y capas territoriales complementarias.

## Capas adicionales automaticas

Los archivos GeoPackage agregados a `data/sample` se cargan y publican automaticamente al iniciar la pila. Para aplicar un estilo, el SLD debe tener exactamente el mismo nombre base que el GeoPackage:

```text
data/sample/Municipio.gpkg
data/sample/Municipio.sld
```

El nombre del archivo se usa como titulo de la capa y se normaliza para crear su tabla en PostGIS. Si el GeoPackage contiene una capa cuyo nombre coincide con el nombre del archivo, se usa esa capa; en caso contrario, se importa la primera capa vectorial disponible. El SLD es opcional: sin él, GeoServer usa su estilo predeterminado.

Despues de agregar o retirar archivos, ejecute:

```bash
docker compose up -d --build
```

La capa CLC principal conserva sus servicios de consulta, estadisticas, reportes y descarga. Las capas adicionales se incorporan al selector del mapa con control de opacidad independiente.

El proyecto integra PostGIS como motor espacial, FastAPI como backend de analisis, GeoServer para publicacion WMS/WFS y un geovisor web ligero para evaluacion funcional.

## Requisitos para ejecutar en otro equipo

La aplicacion se ejecuta completamente con contenedores. No es necesario instalar Python, PostgreSQL, PostGIS, GDAL, GeoServer ni Nginx de forma individual.

Programas requeridos:

- [Git](https://git-scm.com/downloads), para clonar el repositorio.
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) en Windows o macOS. En Windows debe utilizar contenedores Linux y se recomienda el backend WSL 2.
- En Linux, [Docker Engine](https://docs.docker.com/engine/install/) y el complemento [Docker Compose](https://docs.docker.com/compose/install/linux/).

Recursos minimos recomendados para Docker: 4 GB de memoria RAM disponible y 5 GB de espacio libre. Tambien deben estar disponibles los puertos `5432`, `8000`, `8080` y `8081`.

Verifique la instalacion desde una terminal:

```bash
git --version
docker --version
docker compose version
```

## Clonacion e instalacion

Una vez publicado el proyecto en GitHub, clone el repositorio y entre en su carpeta:

```bash
git clone https://github.com/juanjor15/geovisor-clc.git
cd geovisor-clc
```

Cree el archivo local de configuracion.

En Linux, macOS o Git Bash:

```bash
cp .env.example .env
```

En PowerShell:

```powershell
Copy-Item .env.example .env
```

Levante todos los servicios:

```bash
docker compose up -d --build
```

La primera ejecucion puede tardar varios minutos mientras Docker descarga y construye las imagenes. Compruebe el estado con:

```bash
docker compose ps
```

Cuando los servicios aparezcan como `healthy`, abra `http://localhost:8080`. Para detenerlos sin eliminar los datos persistentes ejecute `docker compose down`.

## Alcance Tecnico

La solucion implementa los cinco modulos solicitados en la prueba tecnica:

| Modulo | Componente | Proposito |
|---|---|---|
| 1 | Docker Compose | Orquestacion multi-contenedor, red interna, persistencia y parametrizacion por entorno. |
| 2 | PostGIS | Almacenamiento espacial, esquema controlado, SRID explicito, indices y carga automatizada. |
| 3 | Backend FastAPI | Servicios REST para health check, intersecciones, areas y estadisticas consolidadas. |
| 4 | GeoServer | Publicacion automatizada de servicios OGC WMS/WFS desde PostGIS. |
| 5 | Frontend | Geovisor web para visualizar CLC y ejecutar consultas espaciales. |

## Arquitectura

```text
Browser
  |
  |-- http://localhost:8080
  |       Frontend web
  |
  |-- http://localhost:8000/api/v1
  |       Backend FastAPI
  |
  |-- http://localhost:8081/geoserver
          GeoServer WMS/WFS

Backend FastAPI ---------------> PostGIS
GeoServer ---------------------> PostGIS
```

PostGIS es la fuente de verdad de los datos espaciales. GeoServer consume la tabla publicada en PostGIS y expone servicios OGC. El backend ejecuta los geoprocesos directamente en base de datos usando funciones espaciales de PostGIS y entrega respuestas estructuradas en JSON/GeoJSON.

## Stack

| Capa | Tecnologia |
|---|---|
| Orquestacion | Docker Compose |
| Base de datos espacial | PostgreSQL + PostGIS |
| Backend | Python + FastAPI |
| Servicios OGC | GeoServer |
| Frontend | Leaflet + Nginx |
| Datos | GeoPackage, SLD |
| CRS de analisis | `EPSG:9377` MAGNA-SIRGAS 2018 / Origen-Nacional |

## Estructura del Repositorio

```text
geovisor-clc/
├── backend/
│   ├── app/
│   ├── Dockerfile
│   └── requirements.txt
├── database/
│   ├── init/
│   │   └── 01_postgis.sql
│   ├── scripts/
│   │   └── load_clc.sh
│   └── Dockerfile
├── data/
│   ├── raw/
│   ├── sample/
│   │   ├── CLC_2018.gpkg
│   │   └── CLC_2018.sld
│   └── metadata.md
├── docs/
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── index.html
│   │   └── vendor/
│   ├── Dockerfile
│   └── nginx.conf
├── geoserver/
│   ├── provision/
│   │   └── provision_geoserver.sh
│   ├── styles/
│   │   └── CLC_2018.sld
│   └── user_projections/
│       └── epsg.properties
├── scripts/
├── .env.example
├── .gitignore
├── compose.yml
└── README.md
```

## Estado Verificado

Validacion local con Docker Compose:

```text
postgis                 healthy
backend                 healthy
geoserver               healthy
frontend                healthy
data-loader             exited 0
geoserver-provision     exited 0
```

Servicios verificados:

| Verificacion | Resultado |
|---|---|
| Backend `/api/v1/health` | `200 OK`, conexion activa a PostGIS y conteo de entidades cargadas |
| Backend `/api/v1/statistics` | `37` coberturas, `60808.2319 ha` |
| GeoServer WMS `GetCapabilities` | `200 OK` |
| GeoServer WFS `GetFeature` | `200 OK` |
| GeoServer WMS `GetMap` | `200 OK`, `image/png` |

El repositorio Git esta inicializado localmente. El archivo `.env` esta excluido mediante `.gitignore`.

```text
.gitignore:1:.env    .env
```

## Datos Espaciales

Los datos utilizados corresponden a la capa de Coberturas de la Tierra metodologia CORINE Land Cover adaptada para Colombia, descargada desde [Colombia en Mapas](https://www.colombiaenmapas.gov.co/).

Para esta prueba se preparo una muestra representativa correspondiente al municipio de Pereira, Risaralda.

| Elemento | Valor |
|---|---|
| Fuente | [Colombia en Mapas](https://www.colombiaenmapas.gov.co/) |
| Dataset | Coberturas de la Tierra CLC 2018 |
| Area de interes | Municipio de Pereira, Risaralda |
| Archivo preparado | `data/sample/CLC_2018.gpkg` |
| Capa GeoPackage | `clc_2018_pereira` |
| Geometria | `MULTIPOLYGON` |
| CRS original | `GCS_MAGNA` |
| CRS de analisis | `EPSG:9377` |
| Estilo GeoServer | `data/sample/CLC_2018.sld` |

### Preparacion de Datos

El flujo de preparacion fue:

1. Descarga de la capa CLC 2018 desde [Colombia en Mapas](https://www.colombiaenmapas.gov.co/).
2. Recorte espacial al municipio de Pereira.
3. Reproyeccion de la capa a `EPSG:9377` MAGNA-SIRGAS 2018 / Origen-Nacional.
4. Exportacion del resultado a GeoPackage: `data/sample/CLC_2018.gpkg`.
5. Extraccion del estilo cartografico y conversion a SLD en QGIS usando el complemento SLYR.
6. Almacenamiento del estilo como `data/sample/CLC_2018.sld`.

La reproyeccion a `EPSG:9377` permite ejecutar calculos de area en metros cuadrados dentro de PostGIS. Las respuestas del backend reportan area en hectareas.

## Modelo de Datos PostGIS

Tabla objetivo:

```text
gis.land_cover
```

Campos esperados:

| Campo | Tipo esperado | Descripcion |
|---|---|---|
| `id` | integer | Identificador interno. |
| `codigo` | integer/text | Codigo CLC. |
| `leyenda` | text | Nombre de la cobertura. |
| `nivel_1` a `nivel_6` | text | Jerarquia tematica CLC. |
| `geom` | geometry(MultiPolygon, 9377) | Geometria normalizada para analisis espacial. |

Indices requeridos:

```sql
CREATE INDEX land_cover_geom_gix ON gis.land_cover USING GIST (geom);
CREATE INDEX land_cover_codigo_idx ON gis.land_cover (codigo);
```

## Servicios Docker

| Servicio | Puerto host | Descripcion |
|---|---:|---|
| `postgis` | `5432` | Base PostgreSQL/PostGIS con persistencia. |
| `data-loader` | N/A | Carga automatizada del GeoPackage a PostGIS mediante GDAL/ogr2ogr. |
| `backend` | `8000` | API REST de consulta espacial. |
| `geoserver` | `8081` | GeoServer para WMS/WFS. |
| `geoserver-provision` | N/A | Aprovisionamiento REST de workspace, datastore, capa y estilo. |
| `frontend` | `8080` | Geovisor web servido por Nginx. |

Volumenes persistentes:

| Volumen | Uso |
|---|---|
| `postgis_data` | Datos fisicos de PostgreSQL/PostGIS. |
| `geoserver_data` | Configuracion y catalogo de GeoServer. |

Todos los servicios se conectan mediante la red interna `geovisor_net`. El arranque usa `healthcheck` y `depends_on` para controlar dependencias entre contenedores.

## Variables de Entorno

El archivo `.env.example` contiene la parametrizacion base del proyecto:

```env
POSTGRES_DB=geovisor
POSTGRES_USER=geovisor
POSTGRES_PASSWORD=geovisor
POSTGRES_HOST=postgis
POSTGRES_PORT=5432
POSTGRES_SCHEMA=gis
POSTGRES_TABLE=land_cover

GEOSERVER_ADMIN_USER=admin
GEOSERVER_ADMIN_PASSWORD=geoserver
GEOSERVER_URL=http://geoserver:8080/geoserver
GEOSERVER_WORKSPACE=clc
GEOSERVER_DATASTORE=postgis
GEOSERVER_LAYER=land_cover
GEOSERVER_STYLE=CLC_2018

API_HOST=0.0.0.0
API_PORT=8000
APP_ENV=local

DATA_GPKG_PATH=/data/sample/CLC_2018.gpkg
DATA_GPKG_LAYER=clc_2018_pereira
DATA_SRID=9377
```

El archivo `.env` no debe versionarse. Las credenciales incluidas en `.env.example` son valores locales de desarrollo.

## Ejecucion

Si ya clono y configuro el proyecto mediante la seccion anterior, puede iniciar nuevamente la solucion con:

```bash
docker compose up -d --build
```

URLs esperadas:

| Servicio | URL |
|---|---|
| Frontend | `http://localhost:8080` |
| Backend health | `http://localhost:8000/api/v1/health` |
| Documentacion interactiva API | `http://localhost:8080/api/docs` |
| GeoServer | `http://localhost:8081/geoserver` |

## Backend - Endpoints

| Metodo | Endpoint | Descripcion |
|---|---|---|
| `GET` | `/api/v1/health` | Verifica disponibilidad del API y conexion a PostGIS. |
| `POST` | `/api/v1/intersections` | Calcula coberturas intersectadas por AOI o punto/radio. |
| `GET` / `POST` | `/api/v1/statistics` | Calcula area total y porcentaje por cobertura. |
| `GET` | `/api/v1/metadata` | Entrega metadatos de la muestra, CRS, fuente y capa publicada. |
| `POST` | `/api/v1/reports/spatial-query.pdf` | Genera un informe PDF de la consulta con mapa WMS, grafico y tabla. |
| `GET` | `/api/v1/download?format=geojson\|gpkg\|shapefile` | Descarga la capa completa en el formato seleccionado. |

Los calculos espaciales se ejecutan en PostGIS usando funciones como:

```sql
ST_Intersects
ST_Intersection
ST_Area
ST_MakeValid
ST_AsGeoJSON
```

### Healthcheck

```bash
curl http://localhost:8000/api/v1/health
```

El healthcheck valida conectividad real contra PostGIS, version de PostGIS y conteo de entidades cargadas.

### Estadisticas Consolidadas

```bash
curl http://localhost:8000/api/v1/statistics
```

La respuesta consolida area y porcentaje por cobertura CLC para todo el municipio de Pereira. El calculo se ejecuta directamente en PostGIS sobre `gis.land_cover`.

### Interseccion por Punto y Radio

```bash
curl -X POST http://localhost:8000/api/v1/intersections \
  -H "Content-Type: application/json" \
  -d '{
    "point": {
      "longitude": -75.65559899726748,
      "latitude": 4.784582965492272
    },
    "radius_m": 1000,
    "input_srid": 4326
  }'
```

### Interseccion por Poligono AOI

```bash
curl -X POST http://localhost:8000/api/v1/intersections \
  -H "Content-Type: application/json" \
  -d '{
    "geometry": {
      "type": "Polygon",
      "coordinates": [[
        [-75.665, 4.775],
        [-75.645, 4.775],
        [-75.645, 4.795],
        [-75.665, 4.795],
        [-75.665, 4.775]
      ]]
    },
    "input_srid": 4326
  }'
```

La respuesta de `/api/v1/intersections` se entrega con el tipo MIME `application/geo+json` como `FeatureCollection` GeoJSON en `EPSG:4326`, con propiedades de cobertura CLC, area afectada en metros cuadrados, area afectada en hectareas y porcentaje respecto al area consultada.

### Informe PDF de una Consulta

Despues de ejecutar una consulta espacial con resultados, el visor habilita el boton `Descargar informe PDF`. El informe incluye:

- Imagen del mapa obtenida desde WMS, con limite de la consulta, extension ampliada, proporcion conservada, norte, escala grafica, marco y coordenadas.
- Parametros de la consulta: CRS, coordenadas, vertices, extension y medidas de radio o buffer.
- Tipo de consulta, numero de coberturas y area interceptada.
- Grafico circular sin etiquetas superpuestas, con leyenda porcentual y agrupacion de categorias menores.
- Tabla consolidada de codigo, cobertura, nivel 1, area y porcentaje.

El navegador envia el `FeatureCollection` activo y el `bbox` visible al endpoint `/api/v1/reports/spatial-query.pdf`. La respuesta utiliza `application/pdf` y descarga el archivo `informe_consulta_espacial_clc.pdf`.

El servicio responde con el tipo de contenido `application/geo+json`. Las areas se calculan sobre geometria proyectada en `EPSG:9377`; para consultas de punto y radio, el buffer usa 32 segmentos por cuadrante para reducir el error de aproximacion circular. El total se calcula sobre las areas sin redondear y solo se redondea el resultado final.

La entrada valida los tipos GeoJSON `Point`, `MultiPoint`, `LineString`, `MultiLineString`, `Polygon` y `MultiPolygon`, sus estructuras minimas de coordenadas y el cierre de los anillos. Tambien rechaza combinaciones ambiguas, como enviar simultaneamente `geometry` y `point`, o utilizar `radius_m` sin un punto.

### Descarga de la Capa

El panel **Descargar capa** del geovisor permite exportar todas las entidades y atributos directamente desde PostGIS. El backend genera cada archivo bajo demanda mediante GDAL/OGR y elimina los archivos temporales al finalizar la respuesta.

```bash
curl -OJ "http://localhost:8000/api/v1/download?format=geojson"
curl -OJ "http://localhost:8000/api/v1/download?format=gpkg"
curl -OJ "http://localhost:8000/api/v1/download?format=shapefile"
```

| Formato | Archivo | CRS de salida |
|---|---|---|
| GeoJSON | `CLC_2018_Pereira.geojson` | `EPSG:4326` para interoperabilidad web |
| GeoPackage | `CLC_2018_Pereira.gpkg` | `EPSG:9377` nativo de analisis |
| Shapefile | `CLC_2018_Pereira.zip` con `.shp`, `.shx`, `.dbf`, `.prj` y `.cpg` | `EPSG:9377` nativo de analisis |

El Shapefile se entrega comprimido porque el formato se compone de varios archivos. Los nombres de campo pueden ser abreviados por la limitacion historica de 10 caracteres del formato DBF; GeoJSON y GeoPackage conservan los nombres completos.

En las respuestas del backend, `leyenda` se usa como nombre principal de la cobertura. Los campos `nivel_1`, `nivel_2`, `nivel_3`, `nivel_4`, `nivel_5` y `nivel_6` se entregan como jerarquia tematica CLC complementaria. El campo `codigo` se conserva como referencia tecnica.

### Interseccion por Geometria Dibujada con Buffer

El endpoint `/api/v1/intersections` tambien acepta geometria GeoJSON enviada desde el geovisor. Para geometrias lineales o puntuales dibujadas se debe incluir `buffer_m`, porque la consulta de coberturas requiere un area de analisis.

Ejemplo para una linea con buffer:

```bash
curl -X POST http://localhost:8000/api/v1/intersections \
  -H "Content-Type: application/json" \
  -d '{
    "geometry": {
      "type": "LineString",
      "coordinates": [
        [-75.70, 4.78],
        [-75.64, 4.82],
        [-75.60, 4.80]
      ]
    },
    "buffer_m": 500,
    "input_srid": 4326
  }'
```

Para poligonos dibujados, `buffer_m` no es obligatorio porque el poligono ya representa el area de interes.

### Prueba Automatizada de Intersecciones

Con la solucion levantada, ejecutar:

```bash
python scripts/test_intersections.py
```

La prueba valida punto con radio, poligono AOI, resultado vacio, estructura `FeatureCollection`, tipo MIME GeoJSON, consistencia del total de hectareas y rechazo de entradas invalidas. Para probar otra URL se puede definir `GEOVISOR_BASE_URL`.

## GeoServer

La publicacion OGC esta automatizada mediante el servicio `geoserver-provision`, que consume la REST API de GeoServer despues de que PostGIS, `data-loader` y GeoServer estan disponibles.

- Workspace: `clc`
- Datastore: conexion PostGIS a `gis.land_cover`
- Layer: `land_cover`
- Estilo: `CLC_2018.sld`
- Servicios: WMS y WFS

El aprovisionamiento ejecuta:

1. Creacion o reutilizacion del workspace `clc`.
2. Creacion o actualizacion del datastore PostGIS.
3. Publicacion de la feature type `land_cover`.
4. Registro del estilo `CLC_2018`.
5. Asignacion del estilo como estilo por defecto de la capa.
6. Validacion de WMS `GetCapabilities`.
7. Validacion de WFS `GetFeature`.

GeoServer tambien recibe una definicion custom de `EPSG:9377` en `geoserver/user_projections/epsg.properties`, ya que no todas las distribuciones lo incluyen en su base EPSG interna.

El SLD original exportado desde QGIS/SLYR se conserva en `data/sample/CLC_2018.sld`. Para GeoServer se usa una version compatible en `geoserver/styles/CLC_2018.sld`, eliminando la funcion `to_string` que GeoServer no soporta en filtros SLD y convirtiendo la simbologia a SLD 1.0 con `CssParameter`, para preservar los colores al publicarla por WMS.

La simbologia original utilizaba reglas tipo `left(to_string("codigo_clc"), 3) = '111'`. En GeoServer se reemplazo esa logica por filtros SLD estandar `PropertyIsLike` sobre el campo normalizado `codigo`, usando patrones de prefijo como `111*`, `311*` o `321*`. Esto permite que codigos mas detallados, por ejemplo `31111`, `321111`, `22121` o `3232`, hereden correctamente la simbologia de su clase CLC base y no sean enviados a `all other values`.

Endpoints OGC:

```text
WMS GetCapabilities:
http://localhost:8081/geoserver/clc/wms?service=WMS&version=1.3.0&request=GetCapabilities

WMS GetMap:
http://localhost:8081/geoserver/clc/wms?service=WMS&version=1.1.1&request=GetMap&layers=clc:land_cover&styles=CLC_2018&srs=EPSG:4326&bbox=-75.75,4.65,-75.55,4.90&width=512&height=512&format=image/png

WFS GetFeature:
http://localhost:8081/geoserver/clc/wfs?service=WFS&version=2.0.0&request=GetFeature&typeNames=clc:land_cover&count=1&outputFormat=application/json
```

## Frontend - Geovisor Web

El geovisor se implementa como una aplicacion web estatica servida por Nginx desde el contenedor `frontend`. No requiere proceso de compilacion ni dependencias Node.js, lo que reduce complejidad operativa dentro de la prueba tecnica.

Componentes funcionales:

| Componente | Implementacion |
|---|---|
| Motor de mapa | Leaflet 1.9.4 vendorizado en `frontend/src/vendor/leaflet` |
| Capas base | OpenStreetMap, Esri satelital, Esri topografico |
| Capa tematica | WMS `clc:land_cover` publicado por GeoServer |
| Leyenda | `GetLegendGraphic` desde GeoServer |
| Control de transparencia | Slider integrado bajo la capa WMS CLC dentro del menu flotante de capas |
| Medicion | Menu flotante junto al control de capas para distancia, area, finalizacion y limpieza |
| Consulta espacial | Menu flotante para identificacion directa, buffers, poligono y consulta de la vista |
| Consulta espacial | Consumo de `/api/v1/intersections` |
| Grafico de resultados | Distribucion porcentual de las coberturas obtenidas en cada consulta |
| Informe PDF | Descarga del mapa, grafico circular, metricas y tabla de la consulta activa |
| Estadisticas | Consumo de `/api/v1/statistics` |
| Estado operativo | Consumo de `/api/v1/health` y WMS `GetCapabilities` |

Flujos disponibles en el visor:

1. Visualizacion de la capa CLC publicada como WMS y consulta directa de atributos al hacer clic, sin requerir buffer.
2. Seleccion de mapa base entre OpenStreetMap, Esri satelital y Esri topografico.
3. Control de transparencia de la capa WMS de coberturas, ubicado debajo de la capa en el menu.
4. Leyenda GeoServer colapsable para no ocupar espacio al cargar el visor.
5. Consulta directa de una cobertura al hacer clic, sin buffer, y herramienta independiente de punto con buffer en metros.
6. Herramienta de linea con buffer en metros y consulta automatica al finalizar el dibujo.
7. Herramienta de poligono como area de interes directa y consulta automatica al finalizar el dibujo.
8. Herramienta de medicion de distancia mediante linea dibujada, disponible en un menu flotante junto al de capas.
9. Herramienta de medicion de area mediante poligono dibujado, con resultado dentro del mismo menu flotante.
10. Consulta usando la extension actual del mapa como area de interes.
11. Visualizacion de resultados GeoJSON sobre el mapa.
12. Popups por entidad interceptada con `leyenda`, `codigo`, area, porcentaje y jerarquia `nivel_1` a `nivel_6`.
13. Grafico tipo pastel con la distribucion porcentual de las coberturas interceptadas.
14. Tabla lateral de coberturas interceptadas con area en hectareas y porcentaje del area consultada.
15. Indicadores de salud de API, PostGIS, WMS y SRID de analisis.
16. Descarga de un informe PDF de la consulta activa con mapa, grafico y tabla.

Las herramientas de medicion se ejecutan en el cliente web y no disparan consultas al backend. La distancia se calcula acumulando segmentos sobre coordenadas geograficas con Leaflet, y el area se estima en metros cuadrados para reportar hectareas o kilometros cuadrados segun magnitud.

El visor consume rutas relativas (`/api/v1` y `/geoserver`) expuestas por el proxy Nginx del contenedor `frontend`, por lo que desde el navegador basta acceder a:

```text
http://localhost:8080
```

## PostGIS - Carga Automatizada

La base espacial se inicializa con:

- Extension `postgis`.
- Registro explicito de `EPSG:9377` en `spatial_ref_sys`.
- Esquema `gis`.
- Tabla final `gis.land_cover`.
- Geometria tipada como `geometry(MultiPolygon, 9377)`.
- Indice espacial `GIST` sobre `geom`.
- Indices auxiliares sobre `codigo` y `leyenda`.

La carga inicial se realiza mediante el servicio `data-loader`, construido desde `database/Dockerfile`. Este servicio utiliza GDAL/ogr2ogr para leer `data/sample/CLC_2018.gpkg`, cargar una tabla temporal y normalizar los datos en `gis.land_cover`.

Durante la carga se valida:

- El conteo cargado coincide con el conteo de la capa de entrada en cada GeoPackage.
- Todas las geometrias cargadas son validas.
- Todas las geometrias usan el SRID final configurado (`9377` por defecto).

El registro del sistema de referencia se incluye porque algunas imagenes PostGIS no traen `EPSG:9377` en `spatial_ref_sys` por defecto.

## Criterios de Validacion

La solucion se considera funcional cuando:

- `docker compose up --build` levanta los servicios sin pasos manuales.
- PostGIS queda inicializado con extension espacial, esquema, tabla, SRID e indices.
- La muestra `CLC_2018.gpkg` se carga automaticamente en `gis.land_cover`.
- GeoServer publica la capa desde PostGIS con el estilo SLD asociado.
- El backend responde health check, intersecciones y estadisticas.
- El frontend consume WMS/GeoJSON y muestra resultados de consulta espacial.
- El README documenta instalacion, arquitectura, datos, endpoints y decisiones tecnicas.

## Estado de Implementacion

| Modulo | Estado |
|---|---|
| Modulo 1 - Infraestructura Docker | Base implementada |
| Modulo 2 - PostGIS | Implementado |
| Modulo 3 - Backend | Implementado |
| Modulo 4 - GeoServer | Implementado |
| Modulo 5 - Frontend | Implementado |

## Declaracion de Uso de IA

Durante el desarrollo se utilizo asistencia de IA para interpretar los requerimientos de la prueba, proponer la arquitectura inicial, estructurar el repositorio y apoyar la redaccion tecnica. Todas las decisiones de implementacion, validaciones, ajustes sobre datos geoespaciales y pruebas finales fueron revisadas y pueden ser defendidas por el desarrollador responsable.

El uso de IA no reemplaza la comprension tecnica del proyecto. El desarrollador se compromete a explicar el funcionamiento del codigo, justificar las decisiones de arquitectura y demostrar la solucion ejecutandose correctamente.

## Licencia y datos de terceros

El codigo fuente de este proyecto se distribuye bajo la [licencia MIT](LICENSE).

Los datos geograficos, estilos y demas recursos provenientes de terceros no quedan cubiertos por la licencia MIT. La muestra CORINE Land Cover fue obtenida de [Colombia en Mapas](https://www.colombiaenmapas.gov.co/), plataforma del Instituto Geografico Agustin Codazzi (IGAC), y debe utilizarse conforme a la licencia especifica del conjunto de datos y a los [terminos del portal](https://www.colombiaenmapas.gov.co/colombia-mapas/terminos-y-condiciones/index.html). Consulte tambien [`data/metadata.md`](data/metadata.md) para conocer las transformaciones aplicadas.
