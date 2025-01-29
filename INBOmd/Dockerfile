# build upon the r-base image
FROM docker.io/r-base

# system packages
RUN apt update \
  && apt install libssl-dev libcurl4-openssl-dev --yes # for dependency "gert"

RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'
RUN R -q -e 'install.packages("devtools", dependencies = TRUE)' # for checklist
# RUN R -q -e 'remotes::install_github("inbo/checklist")'
# RUN R -q -e 'install.packages("pdftools")'


# > ERROR: dependencies ‘pkgdown’, ‘roxygen2’, ‘rversions’, ‘urlchecker’
# > ERROR: dependencies ‘codemetar’, ‘devtools’, ‘lintr’, ‘pkgdown’ are not available
# > ERROR: dependencies ‘checklist’, ‘pdftools’ are not available for package ‘INBOmd’

# install from github
# RUN R -q -e 'remotes::install_github("inbo/INBOmd", dependencies = TRUE)'
