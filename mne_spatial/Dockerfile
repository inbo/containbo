FROM docker.io/rocker/rstudio
# (building upon the rocker/rstudio image)

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


# update system packages
# and add ubuntugis repository
# for latest versions of programs in the spatial stack
# and basic system packages for `pak` to proceed
RUN echo "System repositories and packages..." \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    python3 \
    python3-pip \
    software-properties-common \
    vim \
    wget \
  && add-apt-repository --enable-source --yes "ppa:ubuntugis/ubuntugis-unstable" \
  && apt-get autoremove -y && apt-get clean -y \
  && echo "done."


# install geospatial packages
RUN echo "Geospatial packages..." \
  && apt-get update \
  && apt-get full-upgrade -y --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
  && apt-get autoremove -y && apt-get clean -y \
  && echo "done."


# include other repositories via .Rprofile
COPY ./.Rprofile /root/
ENV R_PROFILE_USER=/root/.Rprofile
RUN R -q -e 'getOption("repos")'


# R updates
RUN R -q -e 'update.packages(ask=FALSE)'

RUN echo "Installing BiocManager and pak for furhter package management..." \
  && R -q -e 'install.packages("BiocManager", dependencies = TRUE)' \
  && R -q -e 'install.packages("pak", dependencies = TRUE)' \
  && echo "done."


# R packages, CRAN
RUN echo "installing R packages from various standard sources..." \
 && R -q -e 'pak::pkg_install("arrow", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("BiocManager", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("bookdown", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("brms", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("conquer", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("devtools", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("GGally", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("git2rdata", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("janitor", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("knitr", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("link2GI", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("mitools", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("pROC", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("patchwork", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("permute", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("pkgdown", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("remotes", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("renv", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("reshape", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("reticulate", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("rgrass", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("rmarkdown", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("roxygen2", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("rprojroot", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("rstan", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("snakecase", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("survey", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("terra", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("tidyverse", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("tmvnsim", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("usethis", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("vegan", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("paleolimbot/rbbt", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("cmdstanr", dependencies = TRUE)' \
 && R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."


# R geospatial packages, linking to latest system packages (geos, gdal, proj)
RUN echo "installing additional geospatial packages for R..." \
 && R -q -e 'remotes::install_github("r-spatial/sf")' \
 && R -q -e 'remotes::install_github("rspatial/terra")' \
 && R -q -e 'pak::pkg_install(c("lwgeom", "sp", "stars"), dependencies = TRUE)' \
 && R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."


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
 && R -q -e 'pak::pkg_install("inbo/INBOmd", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/inbodb", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/inbospatial", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/inlatools", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/multimput", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/n2kanalysis", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/n2khab", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/n2khabmon", dependencies = TRUE)' \
 && R -q -e 'pak::pkg_install("inbo/watina", dependencies = TRUE)' \
 && R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."


# "rgdal" is end of life # https://r-spatial.org/r/2022/04/12/evolution.html#packages-depending-on-rgeos-and-rgdal

# RUN R -q -e 'BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)'
# && R -q -e 'pak::pkg_install("pak", dependencies = TRUE)' \


# quarto - latest version
# check quarto releases to update: https://github.com/quarto-dev/quarto-cli/releases
# this layer is volatile and should come late in the build chain.
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.13/quarto-1.7.13-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb
# run `quarto check` for a checkup
RUN quarto install tinytex --update-path
RUN pip3 install jupyter --break-system-packages


### Cleanup Again
RUN R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)'
RUN apt-get autoremove -y
RUN apt-get clean -y
RUN rm -rf /tmp/*


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
#   sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu-nightly `lsb_release -c -s` main" > /etc/apt/sources.list.d/qgis.list'
