#!/bin/bash

# modified from https://github.com/mattbun/arch-sshd/blob/master/start.sh

# Initialize environment variables if they aren't set
USERNAME=${USERNAME:-inbo}
PASSWORD=${PASSWORD:-changeme}
SHELL=${SHELL:-/bin/fish}

echo $USERNAME

# Create User
USERADD_COMMAND="useradd -m -s $SHELL"

if [[ -z $UID ]]; then
  USERADD_COMMAND="$USERADD_COMMAND -u $UID"
fi

eval "$USERADD_COMMAND $USERNAME"

# Change password
echo "${USERNAME}:${PASSWORD}" | chpasswd

# Add user to wheel so they can use sudo
usermod -aG wheel $USERNAME

# Set up locale
echo -e $LOCALE_GEN > /etc/locale.gen
locale-gen
echo -e $LOCALE_CONF > /etc/locale.conf

