# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git

# R packages, CRAN
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'

# R packages, from github
RUN R -q -e 'remotes::install_github("inbo/n2khab", dependencies = TRUE)'

