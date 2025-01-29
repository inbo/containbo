# build upon the r-base image
FROM docker.io/r-base


# install from github
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)'
RUN R -q -e 'remotes::install_github("inbo/watina", dependencies = TRUE)'

# inbodb
# ERROR: odbc units s2 sf
