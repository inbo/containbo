# build upon the r-base image
FROM docker.io/r-base

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
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev

# https://www.r-inla.org/download-install

# R packages, CRAN
RUN R -q -e 'install.packages("fmesher", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
RUN R -q -e 'install.packages("BiocManager")'
RUN R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)'
RUN R -q -e 'install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)'

# RUN R -q -e 'install.packages("HKprocess", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
# 'HKprocess’ https://cran.r-project.org/web/packages/HKprocess/index.html archived!
