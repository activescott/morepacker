#!/bin/bash

function show_usage() {
	echo "test_provision_script.sh user@host"
}

if [[ ! $1 ]]; then
	show_usage
	echo "Must specify remote host!"
	exit 1
fi
REMOTE_HOST=$1
PROVISION_SCRIPT=provision_joomla.sh
DEST=/tmp

scp provision_joomla.sh $REMOTE_HOST:$DEST/$PROVISION_SCRIPT
scp joomla-apache-config.conf $REMOTE_HOST:$DEST/joomla-apache-config.conf

if [[ -f "joomla-db.sql" ]]; then
	scp joomla-db.sql $REMOTE_HOST:$DEST/joomla-db.sql
fi

ssh $REMOTE_HOST "chmod +x $DEST/$PROVISION_SCRIPT; \
	echo packer | sudo -S $DEST/$PROVISION_SCRIPT packer packer packer testdb"
