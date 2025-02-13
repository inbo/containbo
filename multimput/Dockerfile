FROM docker.io/r-base
# (build upon the r-base image)

# for `sf`; ref: https://github.com/rocker-org/geospatial/blob/master/Dockerfile
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    cmake \
    jags \
    lbzip2 \
    libfftw3-dev \
    libfribidi-dev \
    libgdal-dev \
    libgeos-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgsl0-dev \
    libharfbuzz-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    libnetcdf-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libsqlite3-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev


# https://www.r-inla.org/download-install
RUN R -q -e 'install.packages("fmesher", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
RUN R -q -e 'install.packages("BiocManager")'
RUN R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)'
RUN R -q -e 'install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)'


# also requires `sf` and `libgdal`
# note that those are NOT taken from the ubuntugis PPA in this dockerfile,
# see https://wiki.ubuntu.com/UbuntuGIS

RUN R -q -e 'install.packages("remotes")'
RUN R -q -e 'remotes::install_github("inbo/multimput")'
