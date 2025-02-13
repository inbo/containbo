FROM docker.io/rocker/r-base
# (build upon the r-base image)

# update system
RUN echo "System repositories and packages" \
  && apt-get update \
  && apt-get full-upgrade -y --no-install-recommends \
  && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libtiff5-dev \
    libxml2-dev

# #  R -e 'knitr::kable(pak::pkg_deps("devtools"))' > devtools_dependencies
# RUN R -q -e 'install.packages("pak", dependencies = TRUE)'
# RUN R -q -e 'pak::pkg_install("devtools")'

RUN R -q -e 'install.packages("devtools", dependencies = TRUE)'

# ‘pkgdown’, ‘ragg’ <- textshaping <- fribidi
# ‘roxygen2’, ‘rversions’, ‘urlchecker’, ‘rvest’, ‘xml2’, ‘systemfonts’, ‘textshaping’
# libfontconfig1-dev
# libharfbuzz-dev
