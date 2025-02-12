# NOT WORKING


FROM docker.io/rocker/rstudio

# Accept a build argument for the username and set a default value
ARG DEFAULT_USER=containertester

# Set the environment variable for the username
ENV DEFAULT_USER=${DEFAULT_USER}

# Set up the user
RUN if grep -q "1000" /etc/passwd; then \
        userdel --remove "$(id -un 1000)"; \
    fi; \
    /rocker_scripts/default_user.sh
