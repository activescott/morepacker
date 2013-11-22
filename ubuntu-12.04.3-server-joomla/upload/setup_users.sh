#!/bin/bash

##########
# Setup packer user for sudo w/o password requirement:

##########


function show_help() {
	echo "setup_users.sh SUDO_USER"
	echo "    SUDO_USER: The user to configure as an automatic root/sudo."
}

die () {
	show_help
	echo >&2 "$@"
	exit 1
}

function require_sudo() {
	if [ `id -u` -eq 0 ]
	then
		echo "Running as sudo..."
	else
		die "This script must be run as super user (i.e with sudo)!"
	fi
}

SUDO_USER=$1

[ SUDO_USER ] || die "SUDO_USER required!"

require_sudo

echo \"$SUDO_USER        ALL=(ALL)       NOPASSWD: ALL\" >> /etc/sudoers