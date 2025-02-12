# contaINBO

This repository is a collection of Dockerfiles to support you to bring your favorite [INBO packages](https://inbo.github.io) to containers, such as [Docker](https://docs.docker.com) or [Podman](https://docs.podman.io).


The [dockerfiles](https://docs.docker.com/build/concepts/dockerfile) are organized in subfolders; each contains the minimum prerequisites for creating a container based on [Rocker images](https://rocker-project.org).
The underlying OS is [Ubuntu](https://hub.docker.com/_/ubuntu) which in turn builds on [Debian Testing](https://wiki.debian.org/DebianTesting).
Scripts are tested with `r-base`, but should be portable to `rocker/rstudio`.


```{sh}
docker pull docker.io/r-base
```


A tutorial on containerization is in the making: <https://github.com/inbo/tutorials/tree/dev_docker>.


You can consolidate these dockerfiles on demand to derive your own container builds.
The list is incomplete, but you might find similar packages. 
I am accumulating additional examples as I move on.
Feel free to contribute.


# Tips and Tricks

## all updates 

You might want to update system packages upon building:

```{dsl}
# update the system packages
RUN apt update \
    && apt upgrade --yes
    
# update pre-installed R packages
# RUN Rscript -e 'update.packages(ask=FALSE)'
```


## terminal access

You can access the container terminal as follows:

```{sh}
docker run -it <image> bash
```


## `pak` and `r2u`

Using R package managers might simplify Dockerfiles and save you time.


Here is how you can introduce `pak` to your build:

- <https://pak.r-lib.org>

```{}
RUN R -q -e 'install.packages("pak", dependencies = TRUE)'
RUN R -q -e 'pak::pkg_install("<package>")' 
```


For `r2u`, there is a rocker image which you can use as a base for your custom containers.

- <https://github.com/rocker-org/r2u>


```{sh}
docker run -it docker.io/rocker/r2u
```


## private repos

If you require private repo's within the container, copy them in as follows:

```{dsl}
# copy the repo
COPY my_private_repo /opt/my_private_repo

# manually install dependencies
RUN R -q -e 'install.packages("remotes", dependencies = TRUE)' # just an example

# finally, install package from folder
RUN R -q -e 'install.packages("/opt/my_private_repo", repos = NULL, type = "source", dependencies = TRUE)'
```


## quarto

Quarto is available on some pre-packed rocker images (e.g. `rocker/rstudio`).
However, you might prefer the latest version, or adjust system integration.
Option 1: To install quarto from a debian package, either download the `.deb` [listed here](https://quarto.org/docs/get-started) via an entrypoint, and install it:

```{dsl}
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.13/quarto-1.7.13-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb
```

Check quarto releases regularly to get the latest version: https://github.com/quarto-dev/quarto-cli/releases


Option 2: follow [the posit instructions](https://docs.posit.co/resources/install-quarto.html) to get the latest version of quarto.


Option 3: Or use `git` and follow instructions [here](https://github.com/quarto-dev/quarto-cli).
(Requires `xz-utils`.)

```{sh}
git clone https://github.com/quarto-dev/quarto-cli
cd quarto-cli
./configure.sh
```


Additional modules will certainly be useful:

```{sh}
RUN quarto install tinytex --update-path
RUN python3 -m pip install jupyter
```

You can log into the bash and run `quarto check` for a checkup and further extensions.


## renv

- <https://github.com/rstudio/renv/issues/446>

When attampting `docker-compose`, see note here: <https://github.com/rstudio/renv/issues/599>


## geocomputation

https://github.com/geocompx/docker
https://github.com/geocompx/docker/blob/master/dockerfiles/Dockerfile_ubuntugis_unstable

```{} 
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		software-properties-common \
		vim \
		wget \
		ca-certificates \
  && add-apt-repository --enable-source --yes "ppa:marutter/rrutter3.5" \
	&& add-apt-repository --enable-source --yes "ppa:marutter/c2d4u3.5" \ 
	&& add-apt-repository --enable-source --yes "ppa:ubuntugis/ubuntugis-unstable" 
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
 	  libudunits2-dev libgdal-dev libgeos-dev libproj-dev # liblwgeom-dev
# install the r-spatial stack linking to new OSGeo pkgs
RUN R -e 'install.packages(c("sf", "lwgeom", "rgdal", "sp", "stars"))'
```


# List of INBO Packages

- [X] checklist
- [X] inbodb 
- [X] inborutils
- [X] inbospatial
- [X] n2khab
- [X] watina << inbodb
- [X] INBOmd << checklist
- [X] INBOtheme
- [X] INLA <- fmesher
- [X] inlatools
- [X] n2kanalysis << n2khelper multimput < INLA < fmesher


- [X] all in one

(publish to docker hub?)


# Testing

- create a dockerfile
- build it
- enter the terminal and run R

``` sh
docker run --name <container-name> -it <image> bash
# e.g. # docker run --name bash-quicktest -it docker.io/rocker/r-base bash
R --vanilla --silent -q -e 'library("<package>")'
```


Remove all images:

``` sh
docker rmi $(docker images -q)
# or
podman rmi $(podman images -q) -f
```

# Notes

Github has rate limits. If you encounter a `403` upon github installation, wait and repeat.


- httr <- libcurl4-openssl-dev libssl-dev
- xml2 <- libxml2
- units <- libudunits2-dev
- rgbif <- libssl-dev libudunits2-dev libxml2 ++libprotobuf-dev 
- sf <- a whole lot of stuff, incl. units
- usethis <- openssl, curl, credentials, httr2, gert, gh
- pkgdown <- libharfbuzz-dev libfribidi-dev, lib8-dev
- devtools <- ‘usethis’, ‘pkgdown’, ‘rcmdcheck’, ‘roxygen2’, ‘rversions’, ‘urlchecker’
- magick <- libmagick++-dev
- gt <- juicyjuice <- lib8-dev
- ragg <- libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
- checklist <- [usethis, pkgdown, devtools] + librdf0-dev libsodium-dev
- INBOtheme <- libssl-dev libcurl4-openssl-dev git libgit2-dev
- INBOmd <- [checklist, INBOtheme] + libpoppler-cpp-dev
- INLA <- [fmesher devtools] + jags
- n2kanalysis <- [multimput n2khelper RODBC INLA] libcurl4-openssl-dev libgit2 libssl-dev libudunits2-dev cmake libxml2-dev unixodbc-dev

INLA temporary issue?
``` 
# RUN R -q -e 'install.packages("HKprocess", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
# 'HKprocess’ https://cran.r-project.org/web/packages/HKprocess/index.html archived!
```
