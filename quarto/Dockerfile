# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt-get update \
  && apt-get full-upgrade

ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb

# R packages, CRAN
# RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'

# R packages, from github
# RUN R -q -e 'remotes::install_github("inbo/n2khab", dependencies = TRUE)'
