# build upon the r-base image
FROM docker.io/r-base

# system packages; for `odbc`, `units`, `s2`, `xml2`, ...
RUN apt-get update \
  && apt-get install libssl-dev --yes \
  && apt-get install libcurl4-openssl-dev --yes \
  && apt-get install libudunits2-dev --yes \
  && apt-get install libprotobuf-dev --yes \
  && apt-get install git libgit2-dev --yes \
  && apt-get install libxml2 --yes

# for `sf`; ref: https://github.com/rocker-org/geospatial/blob/master/Dockerfile
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev


# install from github
# `inborutils` requires ‘curl’, ‘httr’, ‘leaflet’, ‘rgbif’, ‘sf’
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/inborutils", dependencies = TRUE)'

