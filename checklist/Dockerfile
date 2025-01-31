# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libv8-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libmagick++-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    librdf0-dev \
    libsodium-dev \
    git \
    libgit2-dev

# R packages, CRAN
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'

# R packages, from github
RUN R -q -e 'remotes::install_github("inbo/checklist", dependencies = TRUE)'

