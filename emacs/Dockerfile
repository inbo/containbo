
FROM docker.io/archlinux
# A container to run doom emacs org mode on any system.

# update repo's and install requirements
RUN pacman --noconfirm -Syu \
 && pacman --noconfirm -Sy vim emacs ripgrep fd git fish zsh ttf-mononoki-nerd \
 && pacman --noconfirm -Scc

# setting user variables
# https://www.docker.com/blog/docker-best-practices-using-arg-and-env-in-your-dockerfiles/
# https://vsupalov.com/docker-build-pass-environment-variables/
# you must then build with `--build-arg`s, e.g.
#     podman build --build-arg USERNAME=$USER -t test .
ARG USERNAME="inbo"
ENV USERNAME=$USERNAME
ENV SHELL="/bin/fish"

# a start script go get the user set up
# copied and modified from:
#   https://github.com/mattbun/arch-sshd
# ... and using the environment variables as described below.
COPY start.sh /tmp/start.sh
RUN USERNAME=$USERNAME sh /tmp/start.sh

# see `start.sh` for details.
#   USERNAME - The username to use when logging in, defaults to "inbo"
#   PASSWORD - The password to use when logging in, defaults to "changeme"
#   SHELL - Which shell to use, defaults to "/bin/fish"
#   UID - The UID of the login user, by default left blank
#   LOCALE_GEN - What to put in /etc/locale.gen
#   LOCALE_CONF - What to put in /etc/locale.conf

# # NOT WORKING: get a writable folder for exchange with the host system
# RUN mkdir /data && chown -R $USERNAME:$USERNAME /data && chmod 777 /data
# VOLUME ["/data"]
# # this can NOT YET be used for mounting at runtime with # run [...] -v /path/to/folder:/home/<user>/mountpoint [...] 

# # get entrypoint
# # https://spacelift.io/blog/docker-entrypoint-vs-cmd
# # in this case, a script which switches the user and runs emacs
# # run the container with # run -it -e USERNAME=<user> test
# COPY entrypoint.sh /root/entrypoint.sh
# RUN chmod +x /root/entrypoint.sh
# ENTRYPOINT "/root/entrypoint.sh" # requires permissions for $USERNAME
# # this did not work well with user preparation and switching, due to file permission issues

# # Customization: copy in your (doom) emacs configs
# COPY .doom.d "/home/$USERNAME/.doom.d"

# switch to working user
# https://www.docker.com/blog/understanding-the-docker-user-instruction
# this will also apply to the CMD below, i.e. you will log in as the $USERNAME
USER "$USERNAME"

# # working neither:
# RUN mkdir /home/$USERNAME/data \
#  && chown -R $USERNAME:$USERNAME /home/$USERNAME/data \
#  && chmod 777 /home/$USERNAME/data
# # 

# # install doom emacs for that user
# RUN git clone --depth 1 --single-branch https://github.com/doomemacs/doomemacs ~/.emacs.d \
#  && cd ~/.emacs.d/bin && ./doom install --env --config --install --fonts --force

# USER root
# CMD echo "df $USERNAME" && su - $USERNAME -c emacs # for testing
CMD cd ~ && emacs
