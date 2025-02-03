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
    libharfbuzz-dev \
    libfribidi-dev \
    jags \
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

# Warning messages:
#   installation of package ‘runjags’ had non-zero exit status
# checking for pkg-config... /usr/bin/pkg-config
# configure: WARNING: pkg-config file for jags unavailable
# configure: WARNING: Consider adding the directory containing `jags.pc`
# configure: WARNING: to the PKG_CONFIG_PATH environment variable
# configure: Attempting legacy configuration of rjags
# checking for jags... no
# configure: error: "automatic detection of JAGS failed. Please use pkg-config to locate the JAGS library. See the INSTALL file for details."
# ERROR: configuration failed for package ‘runjags’

#   installation of package ‘ragg’ had non-zero exit status
#   installation of package ‘pkgdown’ had non-zero exit status
#   installation of package ‘devtools’ had non-zero exit status
# >
