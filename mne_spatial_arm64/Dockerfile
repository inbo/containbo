FROM docker.io/rocker/rstudio

# meta information
# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.authors="Falk Mielke <falk.mielke@inbo.be>"
LABEL org.opencontainers.image.created="20250214"
LABEL org.opencontainers.image.url="https://github.com/inbo/containbo"
LABEL org.opencontainers.image.title="MNE Spatial Analyses and Simulations"
LABEL org.opencontainers.image.description="A rather inclusive image for resource-intense computer simulation of the INBO project Monitoring Programme for the Natural Environment (MNE)."
LABEL org.opencontainers.image.base.name="rocker/rstudio"


# provide a basic RStudio config to the container root user (when using podman)
RUN mkdir /root/.config \
 && cp -R /home/rstudio/.config/rstudio /root/.config/


# provide a `/data` folder to store analysis outcomes
VOLUME ["/data"]
# this can  be used for mounting at runtime with # run [...] -v /path/to/folder:/data [...]
# For podman/linux non-root container users, you need to fix a UID on the created user (usually 1000)
# And then run on the host system:
#    podman unshare chown 4200:4200 -R /path/to/share
# cf. https://www.tutorialworks.com/podman-rootless-volumes


# update system packages
# and add ubuntugis repository
# for latest versions of programs in the spatial stack
# and basic system packages for `pak` to proceed
RUN echo "System repositories and packages..." \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libodbc2 \
    apt-utils \
    apt-show-versions \
    ca-certificates \
    cmake \
    git \
    jags \
    lbzip2 \
    libabsl-dev \
    libcurl4-openssl-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
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
    python3 \
    python3-pip \
    software-properties-common \
    sqlite3 \
    tk-dev \
    unixodbc-dev \
    vim \
    wget \
  && apt-get autoremove -y && apt-get clean -y \
  && echo "done."


# include other repositories via .Rprofile
COPY ./.Rprofile /root/
ENV R_PROFILE_USER=/root/.Rprofile
RUN R -q -e 'getOption("repos")'


# R updates
RUN R -q -e 'update.packages(ask=FALSE)'

# ARM note: pak will not work on arm (no binaries available)
# RUN echo "Installing BiocManager and pak for furhter package management..." \
#  && R -q -e 'install.packages("BiocManager", dependencies = TRUE)' \
#  && echo "done."
# && R -q -e 'install.packages("pak", dependencies = TRUE)' \


# R packages, CRAN
RUN echo "installing R packages from various standard sources..." \
 && R -q -e 'install.packages("arrow", dependencies = TRUE)' \
 && R -q -e 'install.packages("BiocManager", dependencies = TRUE)' \
 && R -q -e 'install.packages("bookdown", dependencies = TRUE)' \
 && R -q -e 'install.packages("brms", dependencies = TRUE)' \
 && R -q -e 'install.packages("conquer", dependencies = TRUE)' \
 && R -q -e 'install.packages("devtools", dependencies = TRUE)' \
 && R -q -e 'install.packages("GGally", dependencies = TRUE)' \
 && R -q -e 'install.packages("git2rdata", dependencies = TRUE)' \
 && R -q -e 'install.packages("janitor", dependencies = TRUE)' \
 && R -q -e 'install.packages("knitr", dependencies = TRUE)' \
 && R -q -e 'install.packages("link2GI", dependencies = TRUE)' \
 && R -q -e 'install.packages("mitools", dependencies = TRUE)' \
 && R -q -e 'install.packages("pROC", dependencies = TRUE)' \
 && R -q -e 'install.packages("patchwork", dependencies = TRUE)' \
 && R -q -e 'install.packages("permute", dependencies = TRUE)' \
 && R -q -e 'install.packages("pkgdown", dependencies = TRUE)' \
 && R -q -e 'install.packages("remotes", dependencies = TRUE)' \
 && R -q -e 'install.packages("renv", dependencies = TRUE)' \
 && R -q -e 'install.packages("reshape", dependencies = TRUE)' \
 && R -q -e 'install.packages("reticulate", dependencies = TRUE)' \
 && R -q -e 'install.packages("rgrass", dependencies = TRUE)' \
 && R -q -e 'install.packages("rmarkdown", dependencies = TRUE)' \
 && R -q -e 'install.packages("roxygen2", dependencies = TRUE)' \
 && R -q -e 'install.packages("rprojroot", dependencies = TRUE)' \
 && R -q -e 'install.packages("rstan", dependencies = TRUE)' \
 && R -q -e 'install.packages("snakecase", dependencies = TRUE)' \
 && R -q -e 'install.packages("survey", dependencies = TRUE)' \
 && R -q -e 'install.packages("terra", dependencies = TRUE)' \
 && R -q -e 'install.packages("tidyverse", dependencies = TRUE)' \
 && R -q -e 'install.packages("tmvnsim", dependencies = TRUE)' \
 && R -q -e 'install.packages("usethis", dependencies = TRUE)' \
 && R -q -e 'install.packages("vegan", dependencies = TRUE)' \
 && R -q -e 'install.packages("paleolimbot/rbbt", dependencies = TRUE)' \
 && R -q -e 'install.packages("cmdstanr", dependencies = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."
# && R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)' \

RUN echo "System repositories and packages..." \
  && add-apt-repository --enable-source --yes "ppa:ubuntugis/ubuntugis-unstable" \
  && apt-get autoremove -y && apt-get clean -y \
  && echo "done."

# install geospatial packages
RUN echo "Geospatial packages..." \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
  && apt-get autoremove -y && apt-get clean -y \
  && echo "done."


# R geospatial packages, linking to latest system packages (geos, gdal, proj)
RUN echo "installing additional geospatial packages for R..." \
 && R -q -e 'remotes::install_github("r-spatial/sf")' \
 && R -q -e 'remotes::install_github("rspatial/terra")' \
 && R -q -e 'install.packages(c("lwgeom", "sp", "stars"), dependencies = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."
#&& R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)' \


# INLA
RUN echo "installing INLA..." \
 && R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dependencies = TRUE)' \
 && R -q -e 'install.packages("fmesher", dependencies = TRUE)' \
 && R -q -e 'install.packages("INLA", dependencies = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."

# , repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org")
# ,repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable")


# INBO packages
RUN echo "installing INBO packages for R..." \
 && R -q -e 'remotes::install_github("inbo/INBOmd", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/inbodb", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/inbospatial", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/inlatools", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/multimput", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/n2kanalysis", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/n2khab", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/n2khabmon", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("inbo/watina", dependencies = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."
# && R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)' \


# "rgdal" is end of life # https://r-spatial.org/r/2022/04/12/evolution.html#packages-depending-on-rgeos-and-rgdal

# RUN R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)'
# && R -q -e 'pak::pkg_install("pak", dependencies = TRUE)' \


# quarto - latest version
# check quarto releases to update: https://github.com/quarto-dev/quarto-cli/releases
# this layer is volatile and should come late in the build chain.
# ARM note: get the right arch!
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.13/quarto-1.7.13-linux-arm64.deb /tmp/quarto.deb
RUN echo "installing quarto, tinytex, jupyter..." \
 && dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb \
 && pip3 install jupyter --break-system-packages \
 && R -q -e 'install.packages("tinytex")' \
 && R -q -e 'tinytex::install_tinytex()' \
 && echo "done."

# run `quarto check` for a checkup

# then install TinyTeX
# RUN apt install -y perl
# RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
# RUN quarto install tinytex --update-path


### Cleanup Again
# RUN R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)'
RUN apt-get update \
 && apt-get full-upgrade -y --no-install-recommends \
 && apt-get autoremove -y \
 && apt-get clean -y
RUN rm -rf /tmp/*

# TODO: n2khab data


### solved quetions:
# - gaan we https://geocompr.r-universe.dev nodig hebben? -> waarschijnlijk neen.
# && R -q -e 'pak::pkg_install("mapview", dependencies = TRUE)' \

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
#   sudo sh -c 'echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu-nightly `lsb_release -c -s` main" > /etc/apt/sources.list.d/qgis.list'
