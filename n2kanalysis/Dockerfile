# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libssl-dev \
    libcurl4-openssl-dev \
	libodbc2 \
    cmake \
    unixodbc-dev \
    git \
    libudunits2-dev \
    libgit2-dev

# R packages, CRAN
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'

# R packages, from github
# RUN R -q -e 'remotes::install_github("inbo/multimput", dependencies = TRUE)'
# RUN R -q -e 'remotes::install_github("inbo/n2khelper", dependencies = TRUE)'
# RUN R -q -e 'remotes::install_github("inbo/n2kanalysis", dependencies = TRUE)'
