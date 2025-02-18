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


## RStudio settings

Nothing more convenient than a personalized workspace!
Problem is that changes on the container **are not persistent**, unless you mount volumes from the host system.
Because the container OS is usually linux, there are simple ways to bring your personal settings along; only they are a bit hard to grasp at first encounter.
The following paragraph is a superficial dive into the linux file system organization.


To find your rstudio settings files on the container, enter the container shell and `find` them:

```{sh}
docker run -it docker.io/rocker/rstudio bash
find / -iname "rstudio-prefs.json" 2>/dev/null
```


First observation: 
When you `docker run` the container, change settings, they are reverted upon re-start of the container ([non-persistence](https://docs.docker.com/get-started/docker-concepts/running-containers/persisting-container-data)).

Bad luck.


To circumvent this temporarily, you can mount a local folder from the host to the container.
That is perfectly feasible: store your settings locally (or just provide a place where they get stored), and they get changed from within the container.

```{sh}
docker run -it -p 8787:8787 -v /full/path/to/rstudio_config_subfolder:/home/rstudio/.config/rstudio docker.io/rocker/rstudio
```


Devil lies in the detail: 

- Obviously, exchange `docker.io/rocker/rstudio` for the image you built.
- The above works for a Docker build of `rocker/rstudio`: the default RStudio server user is `rstudio`, so its "home folder" is `/home/rstudio`.
- Within it resides a `.config`, it contains config for RStudio, so the full path to your rstudio configs on the docker is `/home/rstudio/.config/rstudio`.
- There is also a `.config/R` subfolder, which might be filled in situations I did not test or anticipate.
- The path within the container will be overwritten.
- You could mount the entire `.config`, or even the entire `~` (Linux shorthand for "home folder", e.g. `/home/<username>`), but caution is warranted: if the image maintainer stored something inside there, it will be overwritten. Broken or lost configs are no good; be specific and precise with what you mount (although there is little pain in trying and breaking things locally). 
- I also found that `-v` requires full path to the host machine, and tend to store config folders with the Dockerfiles.


I am using `podman`, where the RStudio server login user `root` (:facepalm:) who for some reason does not have RStudio settings by default (:doublefacepalm:) is not negotiable.
The home folder of the root user is `/root`, so the command changes to

```{sh}
podman run -it -p 8787:8787 -v /full/path/to/rstudio_config_subfolder:/root/.config/rstudio <imagename>
```

*There is effectively no other way than mounting your path at runtime.*
You might think that Dockerfile `VOLUME` could help; turns out it does not (see below).


If you are fine with a one-time shot of bringing your local/personal/predefined configs to the container, you might instead `COPY` or `ADD` them in.
For example, because most assets in the `~/.config` folder are text files, it makes sense to maintain this important, personal folder in a git repository (which could be called upon in the Dockerfile). 
One step further, [GNU `stow`](https://www.gnu.org/software/stow) is an excellent tool to manage only the relevant subset of your ".dotfiles", as the geeks call them (e.g. [this instruction video](https://systemcrafters.net/managing-your-dotfiles/using-gnu-stow)).


You might find all this information intimidating. 
And certainly it is, for people unfamiliar with Linux.
But rest assured: by applying and understanding these highly logical concepts, you grow, you learn, you can get creative ;)


## understanding VOLUMEs

For portability, you might want to use [Dockerfile volumes](https://docs.docker.com/reference/dockerfile/#volume).
Trouble is: **They are NOT REALLY used for portability** as you would naïvely understand it; they are for *persistence* of files from the container which would otherwise be lost.
In other words, they offer a one-way solution to bring and keep container files from container to the host at runtime.
Think, for example, of log files or user input on a little web server container, which you would want to keep even after the container is restarted or shut down.
Repeat: this is about `VOLUME` in a Dockerfile; this is not about `docker run -v [...]`.
[More references here.](https://stackoverflow.com/a/49173474)

Here is what I tested.
With Docker, try:

```{}
VOLUME /home/rstudio/.config
```

Or with Podman, where you would also want to copy the `.config` of the `rstudio` user, you would instead want to:

```{}
RUN mkdir /root/.config \
 && cp -R /home/rstudio/.config/rstudio /root/.config/
VOLUME /root/.config
```


This by itself does **not** make the .config volume persistent over instances/sessions; you will still need to mount another folder from the host.
The following commands might be useful:

```{sh}
docker volume ls
docker volume export [...]
```

I found more info on this [here](https://stackoverflow.com/a/38299025).

Because of the volatile nature of a docker container, mounting of a host path has to be done with the `docker run -v /host/path:/container/path`; make sure to spell out both paths.

When using Podman, there is the extra complication of user IDs (cf. ["Using volumes with rootless podman, explained" by Tom Donohue](https://www.tutorialworks.com/podman-rootless-volumes)).
Mounting a folder with `rw` permissions for non-root within the container requires knowledge of the UID within the container (linux: `id` command), and one extra command on the host:

```{sh}
podman unshare chown UID:GID -R /host/path/to/share
```

For details, see the `./emacs` recipe.


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
From the host machine, `docker images` will give you a table with sizes.
You can further investigate within the container:

```{sh}
df -h # will show the remaining disk space
du -sh /tmp/* # "disk usage", will show size of subfolders in the specified path
```


I also noted that docker will keep the virtual drive space large, even after removing files within the container.
The container volume seems to refuse to shrink!

This justifies some extra care with the increase of volume size during the build process.
*Every command in the Dockerfile creates a new "layer"*, which enables docker caching of intermediate stages.
If those layers increase virtual disk volume, there is no turing back.
Which is why it might make sense to clean up at the end of every build step. 

The following commands can help you:

```{}
RUN R -q -e 'pak::pak_cleanup(package_cache = TRUE, metadata_cache = TRUE, pak_lib = TRUE, force = TRUE)'
RUN apt-get autoremove -y \
 && apt-get clean -y
RUN rm -rf /tmp/*
```

Know that commands can be chained in Linux with the **double ampersand operator `&&`**, which means: "wait for one command to finish, then execute the next". 
Compare to a single ampersand `&`: this can be used to execute commands in parallel (not generally a good idea for build instructions).


When optimizing a build stack, you can use `docker image history` to show disk usage of the individual steps ([via](https://bell-sw.com/blog/how-to-reduce-the-size-of-docker-container-images)).

```{sh}
docker image history <image_name>
```


This behavior might be annoying enough so that you decide to quit docker forever.
In that case, you can remove all images and instances with the following commands.

```{sh}
# sensible(?) pruning
docker system prune
docker builder prune
docker volume prune

# radical cleanup
docker rmi $(docker images -q)
```

## Users and Environment Variables

Some rather advanced tricks on linux user handling and the use of environment variables are available in the `./emacs` Dockerfile.
In the example case, you can choose a username in the container via a `--build-arg`;
the user is created during build and chosen for startup via `CMD`.
It is also possible to run a custom startup script as an entrypoint.

The image itself is a minimal arch linux setup with emacs.


## Multiarch Cross Compiling

Some of the servers we use work on `arm64` architecture.
To test locally whether a Dockerfile would work, it is recommended to cross build to `--platform=linux/arm64`.

On a linux host machine, this is enabled by [`qemu`](https://wiki.archlinux.org/title/QEMU) and facilitated by [`buildah`](https://wiki.archlinux.org/title/Buildah)


Install `qemu` (including other relevant qemu-packages) and `buildah`.

```
pacman -Sy qemu-base qemu-system-aarch64 qemu-user-static qemu-user-static-binfmt buildah
```

Then, build using `buildah`:

```
buildah bud --platform=linux/arm64 .
```

Note: cross-platform building will take much longer than the usual procedure!


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

