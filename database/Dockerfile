FROM ghcr.io/osgeo/gdal:ubuntu-small-latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /loader

COPY scripts/load_clc.sh /loader/load_clc.sh
RUN chmod +x /loader/load_clc.sh

CMD ["/loader/load_clc.sh"]
