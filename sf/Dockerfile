
FROM docker.io/rocker/geospatial
# (building upon the rocker/r-base image)


# update system packages
# and add ubuntugis repository
# for latest versions of programs in the spatial stack
RUN echo "System repositories and packages" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    software-properties-common \
    vim \
    wget \
  && add-apt-repository --enable-source --yes "ppa:ubuntugis/ubuntugis-unstable" \
  && echo "done."

RUN echo "Geospatial packages..." \
  && apt-get update \
  && apt-get full-upgrade -y --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
  && echo "done."

# R updates
RUN R -q -e 'update.packages(ask=FALSE)'

# R packages, CRAN
RUN echo "installing R packages from the posit public package manager (https://p3m.dev)..." \
 && R -q -e 'install.packages("remotes", dependencies = TRUE)' \
 && R -q -e 'remotes::install_github("r-spatial/sf")' \
 && R -q -e 'remotes::install_github("rspatial/terra")' \
 && R -q -e 'install.packages(c("lwgeom", "stars"), dependencies = TRUE)' \
 && echo "done."

