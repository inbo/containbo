# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libssl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libudunits2-dev \
    libabsl-dev \
    libxml2-dev \
    unixodbc-dev \
    git \
    libgit2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
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

# R packages, CRAN
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'

# R packages, from github
RUN R -q -e 'remotes::install_github("inbo/n2khabmon", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/n2khab", dependencies = TRUE)'




# ‘googledrive’, ‘googlesheets4’, ‘httr’, ‘ragg’, ‘rvest’, ‘xml2’
# ‘curl’, ‘git2rdata’, ‘sf’ are not available for package ‘n2khab’
# n2khabmon textshaping ragg tidyverse
