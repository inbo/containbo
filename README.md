# contaINBO - recipes for container production

This repository is a collection of Dockerfiles to support you to bring your favorite [INBO packages](https://inbo.github.io) to containers, such as [Docker](https://docs.docker.com) or [Podman](https://docs.podman.io).
These files provide **basis recipes** for assembling your own Dockerfiles, or **inclusive image build instructions** for images in preparation for roll-out.


The [dockerfiles](https://docs.docker.com/build/concepts/dockerfile) are organized in subfolders.
The "recipe" Dockerfiles contains the minimum prerequisites for creating a container based mostly on [Rocker images](https://rocker-project.org), mostly `r-base`, yet that should be interchangeable with `rocker/rstudio`, `rocker/geospatial`, or `rocker/tidyverse`.
The underlying OS is [Ubuntu](https://hub.docker.com/_/ubuntu) which in turn builds on [Debian Testing](https://wiki.debian.org/DebianTesting).


```{sh}
docker pull docker.io/r-base
```


A tutorial on containerization is in the making: <https://github.com/inbo/tutorials/tree/dev_docker>.

Some container images used in production are available on docker hub: <https://hub.docker.com/u/inbobmk>.


You can consolidate the included dockerfiles on demand to derive your own container builds.
The list is incomplete, but you might find similar packages. 
I am accumulating additional examples as I move on.
Feel free to contribute.


# Tips and Tricks

## all updates 

You might want to update system packages upon building:

```{}
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


## An Integrated Package Manager: `pak` 

Using R package managers might simplify Dockerfiles and save you time.


Here is how you can introduce `pak` to your build:

- <https://pak.r-lib.org>

```{}
RUN R -q -e 'install.packages("pak", dependencies = TRUE)'
RUN R -q -e 'pak::pkg_install("<package>")' 
```

The leaders of the `pak` maintain a useful database of package dependencies, which you can query using `pak::pkg_deps` or `pak::pkg_deps_tree`.

```{sh}
R -e 'knitr::kable(pak::pkg_deps("devtools"))' > devtools_dependencies

# or
R -e 'pak::pkg_deps_tree("inbo/inbospatial")'
```

To get binaries from diverse sources, these repositories might be useful:

```{r}
options(
  repos =
    c(
      INLA = "https://inla.r-inla-download.org/R/stable",
      fmesher = "https://inlabru-org.r-universe.dev",
      inbo = "https://inbo.r-universe.dev",
      mcstan = "https://mc-stan.org/r-packages",
      rlib = "https://r-lib.r-universe.dev",
      ropensci = "https://ropensci.r-universe.dev",
      rstudio = "https://rstudio.r-universe.dev",
      rstudioCRAN = "https://cran.rstudio.com",
      tidyverse = "https://tidyverse.r-universe.dev", 
      getOption("repos")
    )
)
```

Those can be involved via an environment variable, see below.


The `pak` workflow involves binaries, which is quick. 
However, some situations (e.g. packages linking against volatile system dependencies such as those of the geospatial stack, e.g. exotic dependencies such as INLA) require building from source.


## Bringing R To You: `r2u`

There is the option to install R packages via system binaries in Ubuntu via `r2u` ([reference](https://github.com/eddelbuettel/r2u)).

For `r2u`, there is a rocker image which you can use as a base for your custom containers.

- <https://github.com/rocker-org/r2u>


```{sh}
docker run -it docker.io/rocker/r2u
```


## customizing R startup and environment variables

To execute custom preparations upon each R startup, [an `.Rprofile` file](https://rstats.wtf/r-startup.html#rprofile) can be used.
For example, you might want to fix the `options(repos = ...)` from above for permanent reference.


Bringing this into the container with a `COPY` layer:

```{}
COPY ./.Rprofile /root/
```


The folder `/root/` is the home folder of the rood user which is used to run commands during the build process, so normally this would suffice. 
Make sure that the folder does not contain any prior `.Rprofile` yet (`ls -a /root/` on the container bash).

However, to ensure that the profile is active, there is the `R_PROFILE_USER` environment variable
which 


(i) [can be passed into the container](https://www.baeldung.com/ops/dockerfile-env-variable)...

```{}
ENV R_PROFILE_USER /root/.Rprofile
RUN R -q -e 'getOption("repos")' # to check
```


... or (ii) set upon every `RUN R`.

```{}
RUN R_PROFILE_USER=/root/.Rprofile R -q -e 'pak::pkg_install("inbo/n2khab")'
```


Further reading: 

- <https://docs.posit.co/ide/user/ide/guide/environments/r/managing-r.html>
- <https://solutions.posit.co/envs-pkgs/environments>


## private repos

If you require private repo's within the container, copy them in as follows:

```{}
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

```{}
ADD https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.13/quarto-1.7.13-linux-amd64.deb /tmp/quarto.deb
RUN dpkg -i /tmp/quarto.deb && rm /tmp/quarto.deb
```

Check quarto releases regularly to get the latest version: https://github.com/quarto-dev/quarto-cli/releases

Note that the `ADD` command is not subject to caching, and should be placed as late as possible in the Dockerfile build chain.


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


## Github Rate Limit

```{}
Downloading GitHub repo inbo/watina@HEAD
Error: Failed to install 'unknown package' from GitHub:
  HTTP error 403.
  API rate limit exceeded for <IP> (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)

  Rate limit remaining: 0/60
  Rate limit reset at: 2025-02-13 08:57:05 UTC

  To increase your GitHub API rate limit
  - Use `usethis::create_github_token()` to create a Personal Access Token.
  - Use `gitcreds::gitcreds_set()` to add the token.
Execution halted
```

"Good news", they call it? :/

If you run to many busy `remotes::install_github` in a Dockerfile build,
Github might lock you out.


Two options:
- Split your `RUN` command, so that you can repeat again after the refractory period.
- Try binary package sources, like `r-universe`, or switch to `pak`.


## Hard Drive Space

Experimenting with these container recipes might quickly fill your drive.

```{sh}
df -h
```


To clean up, remove images and instances with the following commands.

```{sh}
# sensible pruning
docker system prune

# radical cleanup
docker rmi $(podman images -q)
```


# List of INBO Packages

- [X] INBOmd << checklist
- [X] INBOtheme
- [X] INLA << fmesher, sf
- [X] checklist
- [X] devtools
- [X] inbodb 
- [X] inborutils
- [X] inbospatial
- [X] inlatools
- [X] multimput << INLA, sf
- [X] n2kanalysis << n2khelper multimput < INLA < fmesher, sf
- [X] n2khab
- [X] pak
- [X] sf, terra (via rocker/geospatial)
- [X] watina << inbodb


- [X] all in one: mne-spatial

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


# Technical Notes

Some critical branching points and limited dependency trees.

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
- multimput <- INLA


INLA temporary issue?
``` 
# RUN R -q -e 'install.packages("HKprocess", repos = c("https://inlabru-org.r-universe.dev", "https://cloud.r-project.org"))'
# 'HKprocess’ https://cran.r-project.org/web/packages/HKprocess/index.html archived!
```


geospatial binaries?
```
Linking to GEOS 3.12.2, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
WARNING: different compile-time and runtime versions for GEOS found:
Linked against: 3.12.2-CAPI-1.18.2 compiled against: 3.12.1-CAPI-1.18.1
It is probably a good idea to reinstall sf (and maybe lwgeom too)
```

-> issue that GDAL etc. differ in versions
-> install `c("sf", "terra")` from source first!

