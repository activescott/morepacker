#!/bin/bash
export PACKER_LOG=1
export PACKER_LOG_PATH=./packer.log
#NOTE: erb is from ruby. Tested with ruby 1.9.3p385
erb packer.json.erb > ./packer.json.tmp

function show_help() {
	echo "build.sh MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE"
	echo "    MYSQL_USER:     The name of the user to provision in mysql used for joomla."
	echo "    MYSQL_PASSWORD: The password for the user to provision in mysql used for joomla."
	echo "    MYSQL_DATABASE: The name of the database to create in mysql that joomla will use."
}

die () {
	show_help
	echo >&2 "$@"
	exit 1
}

MYSQL_USER=$1
MYSQL_PASSWORD=$2
MYSQL_DATABASE=$3

[ $MYSQL_USER ] || die "MYSQL_USER must be specified."
[ $MYSQL_PASSWORD ] || die "MYSQL_PASSWORD must be specified."
[ $MYSQL_DATABASE ] || die "MYSQL_DATABASE must be specified."

#PACKER_DEBUG=-debug #set it to empty to turn off debug.

packer build $PACKER_DEBUG \
	-var 'MYSQL_USER=$MYSQL_USER' \
	-var 'MYSQL_PASSWORD=$MYSQL_PASSWORD' \
	-var 'MYSQL_DATABASE=$MYSQL_DATABASE' \
	packer.json.tmp
