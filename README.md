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

You might want to update system packages upon building:

```{dsl}
# update the system packages
RUN apt update \
    && apt upgrade --yes
    
# update pre-installed R packages
# RUN Rscript -e 'update.packages(ask=FALSE)'
```


You can access the container terminal as follows:

```{sh}
docker run -it --entrypoint /bin/bash <image>
```


# List of INBO Packages

- [ ] checklist
- [X] inbodb 
- [ ] inborutils
- [ ] inbospatial
- [ ] n2kanalysis
- [ ] n2khab
- [ ] watina << inbodb
- [ ] INBOtheme
- [ ] INBOmd << checklist

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


