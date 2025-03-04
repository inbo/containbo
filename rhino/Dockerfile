FROM ghcr.io/rhino-linux/docker:latest

USER root

ENV TERM=linux

RUN echo "System repositories and packages..." \
 && apt update -y \
 && apt install -y --no-install-recommends \
   apt-show-versions \
   apt-utils \
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
   libodbc2 \
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
   r-base \
   r-base-dev \
   software-properties-common \
   sqlite3 \
   tk-dev \
   unixodbc-dev \
   vim \
   wget \
 && apt-get autoremove -y && apt-get clean -y \
 && echo "done."

# rstudio
# https://wiki.rhinolinux.org/user/rpk
# https://pacstall.dev
RUN pacstall -U \
 && pacstall -I rstudio-deb -P -Ns

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


RUN echo "installing R packages from various standard sources..." \
 && R -q -e 'install.packages("remotes", dependencies = TRUE)' \
 && echo "done."

# R geospatial packages, linking to latest system packages (geos, gdal, proj)
RUN echo "installing additional geospatial packages for R..." \
 && R -q -e 'remotes::install_github("r-spatial/sf")' \
 && R -q -e 'remotes::install_github("rspatial/terra")' \
 && R -q -e 'install.packages(c("lwgeom", "sp", "stars"), dependencies = TRUE)' \
 && rm -rf /tmp/* \
 && echo "done."

# quarto - latest version
# check quarto releases to update: https://github.com/quarto-dev/quarto-cli/releases
# this layer is volatile and should come late in the build chain.
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.13/quarto-1.7.13-linux-amd64.deb /tmp/quarto.deb
RUN echo "installing quarto, tinytex, jupyter..." \
 && dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb \
 && pip3 install jupyter --break-system-packages \
 && R -q -e 'install.packages("tinytex")' \
 && R -q -e 'tinytex::install_tinytex()' \
 && echo "done."


