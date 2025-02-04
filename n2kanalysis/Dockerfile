# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    cmake \
    git \
    jags \
    lbzip2 \
    libcurl4-openssl-dev \
    libfftw3-dev \
    libfribidi-dev \
    libgdal-dev \
    libgeos-dev \
    libgit2-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgsl0-dev \
    libharfbuzz-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    libnetcdf-dev \
	libodbc2 \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev

# R packages, CRAN
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'
RUN R -q -e 'install.packages("fmesher", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'

# INLA
RUN R -q -e 'install.packages("BiocManager")'
RUN R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)'
RUN R -q -e 'install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)'

# R INBO packages, from github
RUN R -q -e 'remotes::install_github("inbo/n2kanalysis", dependencies = TRUE)'
