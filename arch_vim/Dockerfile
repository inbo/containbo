
MAINTAINER Falk Mielke

# build upon a plain arch linux image
FROM docker.io/archlinux

# install system packages
RUN pacman-key --init && pacman-key --populate archlinux
RUN pacman -Syu --noconfirm archlinux-keyring
RUN pacman -Syu --noconfirm git vim neovim xclip fish ripgrep fd ttf-mononoki-nerd emacs

# change the shell
RUN chsh -s /usr/bin/fish

# spacevim
ADD https://spacevim.org/install.sh /tmp/spacevim.sh
RUN sh /tmp/spacevim.sh

# doom emacs
COPY .doom.d /root/.doom.d
RUN git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d/
RUN ~/.emacs.d/bin/doom install --env --fonts -!

# set the entry point
# ENTRYPOINT /usr/bin/fish
