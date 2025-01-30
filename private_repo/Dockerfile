# this is just for TESTING
# you can attempt to replace `eigentoolbox` by any local git folder

# build upon the r-base image
FROM docker.io/r-base

# copy the repo folder
COPY a_private_repo /opt/a_private_repo

# make sure all dependencies are installed
RUN R -q -e 'install.packages(c("dplyr", "assertthat"))'

# install from local folder
RUN R -q -e 'install.packages("/opt/a_private_repo/", repos = NULL, type = "source")'
