# build upon the r-base image
FROM docker.io/r-base

# system packages; for `odbc`, `units`, `s2`, `xml2`, ...
RUN apt-get update \
  && apt-get install libssl-dev libcurl4-openssl-dev unixodbc-dev --yes \
  && apt-get install libudunits2-dev libabsl-dev libxml2 --yes \
  && apt-get install git libgit2-dev --yes

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
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'

# prerequisite: inbodb
RUN R -q -e 'remotes::install_github("inbo/inbodb", dependencies = TRUE)'

# extra: watina
RUN R -q -e 'remotes::install_github("inbo/watina", dependencies = TRUE)'
