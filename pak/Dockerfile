FROM docker.io/rocker/r-base

# update system
RUN apt-get update \
  && apt-get full-upgrade -y --no-install-recommends \
  && apt-get install -y --no-install-recommends \
     libcurl4-openssl-dev \
     libssl-dev

# install pak
RUN R -q -e 'install.packages("pak", dependencies = TRUE)'

# install a package
RUN R -q -e 'pak::pkg_install("PAMmisc")' # contains the Wigner-Ville Transform
