FROM docker.io/rocker/rstudio
# finding out where the rstudio settings are located.
# testing with `podman`, i.e. the rstudio user is `root`

RUN mkdir /root/.config \
 && cp -R /home/rstudio/.config/rstudio /root/.config/
VOLUME /root/.config

# This attempt did not achieve what I intended, but I learned something (see README.md / "understanding VOLUMEs").
