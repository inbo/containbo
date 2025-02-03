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


ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb

# R updates
RUN R -q -e 'update.packages(ask=FALSE)'

# R packages, CRAN
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'
RUN R -q -e 'install.packages("devtools", dependencies = TRUE)'
RUN R -q -e 'install.packages("reticulate", dependencies = TRUE)'
RUN R -q -e 'install.packages("tidyverse", dependencies = TRUE)'
RUN R -q -e 'install.packages("bookdown", dependencies = TRUE)'
RUN R -q -e 'install.packages("git2rdata", dependencies = TRUE)'
RUN R -q -e 'install.packages("arrow", dependencies = TRUE)'
RUN R -q -e 'install.packages("rstan", dependencies = TRUE)'
RUN R -q -e 'install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))'
RUN R -q -e 'install.packages("brms", dependencies = TRUE)'
RUN R -q -e 'install.packages("usethis", dependencies = TRUE)'
RUN R -q -e 'install.packages("pkgdown", dependencies = TRUE)'
RUN R -q -e 'install.packages("roxygen2", dependencies = TRUE)'
RUN R -q -e 'install.packages("rprojroot", dependencies = TRUE)'

# R packages, from github
RUN R -q -e 'remotes::install_github("inbo/INBOmd", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/inbodb", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/inbospatial", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/n2khabmon", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/n2khab", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/watina", dependencies = TRUE)'
