LABEL version="1.0" maintainer="Falk Mielke <falk.mielke@inbo.be>"

# build upon the r-base image
FROM docker.io/rocker/rstudio

# system packages
RUN apt-get update \
  && apt-get full-upgrade -y --no-install-recommends
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    lbzip2 \
    libabsl-dev \
    libcurl4-openssl-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
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
    libjpeg-dev \
    libjq-dev \
    libmagick++-dev \
    libnetcdf-dev \
    libpng-dev \
    libpoppler-cpp-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    librdf0-dev \
    libsodium-dev \
    libsqlite3-dev \
    libssl-dev \
    libtiff5-dev \
    libudunits2-dev \
    libv8-dev \
    libxml2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev

# quarto
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb

# R updates
RUN R -q -e 'update.packages(ask=FALSE)'

# R packages, CRAN
RUN R -q -e 'install.packages("arrow", dependencies = TRUE)' \
 && R -q -e 'install.packages("bookdown", dependencies = TRUE)' \
 && R -q -e 'install.packages("BiocManager", dependencies = TRUE)' \
 && R -q -e 'install.packages("brms", dependencies = TRUE)' \
 && R -q -e 'install.packages("devtools", dependencies = TRUE)' \
 && R -q -e 'install.packages("git2rdata", dependencies = TRUE)' \
 && R -q -e 'install.packages("pkgdown", dependencies = TRUE)' \
 && R -q -e 'install.packages("remotes", dependencies = TRUE)' \
 && R -q -e 'install.packages("renv", dependencies = TRUE)' \
 && R -q -e 'install.packages("reticulate", dependencies = TRUE)' \
 && R -q -e 'install.packages("roxygen2", dependencies = TRUE)' \
 && R -q -e 'install.packages("rprojroot", dependencies = TRUE)' \
 && R -q -e 'install.packages("rstan", dependencies = TRUE)' \
 && R -q -e 'install.packages(c("sf", "lwgeom"), dependencies = TRUE)' \
 && R -q -e 'install.packages("stars", dependencies = TRUE)' \
 && R -q -e 'install.packages("terra", dependencies = TRUE)' \
 && R -q -e 'install.packages("tidyverse", dependencies = TRUE)' \
 && R -q -e 'install.packages("usethis", dependencies = TRUE)' \
 && echo "done."

RUN R -q -e 'install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))'
RUN R -q -e 'install.packages("fmesher", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
RUN R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)'
RUN R -q -e 'install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)'


# R INBO packages, from github
RUN R -q -e 'remotes::install_github("inbo/INBOmd", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/inbodb", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/inbospatial", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/n2kanalysis", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/n2khab", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/n2khabmon", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/watina", dependencies = TRUE)'

# geospatial
# renv + renv.lock
# https://github.com/r-spatial/qgisprocess/blob/49ffca7362597582ae1d2e890c3cc46342d7874a/.github/workflows/R-CMD-check.yaml#L55
# https://github.com/r-spatial/qgisprocess/blob/49ffca7362597582ae1d2e890c3cc46342d7874a/.github/workflows/R-CMD-check.yaml#L79-L80

# extra repo https://geocompr.r-universe.dev
#   mkdir ../extra_plugins
#   echo "QGIS_PLUGINPATH=$(pwd)/../extra_plugins" >> $GITHUB_ENV
# ENV R_VERSION="4.4.2"
#   echo "::endgroup::"
#   echo "::group::Install the QGIS Signing Key"
#   sudo wget -qO /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
#   echo "::endgroup::"

# Add repo to install QGIS development version for Ubuntu (using an often outdated GRASS release from Ubuntu repo)
#   sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu-nightly `lsb_release -c -s` main" > /etc/apt/sources.list.d/qgis.list'

# Add repos to install upcoming QGIS point release (becoming latest release in < 1 month) for Ubuntugis (ubuntugis-unstable PPA, with current GRASS release)
#   sudo mkdir -p /root/.gnupg
#   sudo chmod 700 /root/.gnupg
#   sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/ubuntugis-unstable-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6B827C12C2D425E227EDCA75089EBE08314DF160
#   sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ubuntugis-unstable-archive-keyring.gpg] http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu `lsb_release -c -s` main" > /etc/apt/sources.list.d/ubuntugis-unstable.list'
#   sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntugis-nightly-release `lsb_release -c -s` main" > /etc/apt/sources.list.d/qgis.list'

# https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
# sudo add-apt-repository 'deb [arch=amd64] https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable'

# renv
# https://github.com/rstudio/renv/issues/446
