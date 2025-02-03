# contaINBO

This repository is a collection of Dockerfiles to support you to bring your favorite [INBO packages](https://inbo.github.io) to containers, such as [Docker](https://docs.docker.com) or [Podman](https://docs.podman.io).


The [dockerfiles](https://docs.docker.com/build/concepts/dockerfile) are organized in subfolders; each contains the minimum prerequisites for creating a container based on [Rocker images](https://rocker-project.org).
The underlying OS is [Debian Testing](https://wiki.debian.org/DebianTesting).
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
docker run -it --entrypoint /bin/bash <image>
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

To install quarto, either download the `.deb` [listed here](https://quarto.org/docs/get-started) via an entrypoint, and install it:

```{dsl}
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb
```


Or follow [the posit instructions](https://docs.posit.co/resources/install-quarto.html) to get the latest version.


Or use `git` and follow instructions [here](https://github.com/quarto-dev/quarto-cli).
(Requires `xz-utils`.)

```{sh}
git clone https://github.com/quarto-dev/quarto-cli
cd quarto-cli
./configure.sh
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
- [ ] n2kanalysis << n2khelper multimput < INLA < fmesher


- [ ] all in one
  + tidyverse
  + bookdown

(publish to docker hub?)


# Testing

- create a dockerfile
- build it
- enter the terminal and run R

``` sh
docker run -it --entrypoint /bin/bash <image>
R --vanilla --silent -q -e 'library("<image>")'
```


Remove all images:

``` sh
docker rmi $(docker images -q)
# or
podman rmi $(podman images -q) -f
```

# Notes

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

n2kanalysis <- ‘multimput’, ‘n2khelper’, ‘RODBC’ libcurl4-openssl-dev libgit2 libssl-dev libudunits2-dev cmake libxml2-dev
sql.h and sqlext.h via unixodbc-dev?


``` 
# RUN R -q -e 'install.packages("HKprocess", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
# 'HKprocess’ https://cran.r-project.org/web/packages/HKprocess/index.html archived!
```
