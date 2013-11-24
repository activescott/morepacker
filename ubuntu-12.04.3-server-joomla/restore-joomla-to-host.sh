#!/bin/bash

########## 
# Deploys a backup to the specified host over SSH:

show_help () {
	echo "Usage: restore-joomla-to-host.sh USER@HOST SOURCE_FILES SOURCE_DB MYSQL_DB MYSQL_PW"
	echo " USER         The user to login via SSH with to deploy on the host."
	echo " HOST         The hostname or IP address to deploy to."
	echo " SOURCE_FILES The root directory of the site files to copy."
	echo " SOURCE_DB    A MySQL .sql file created with something like mysqldump. Will be executed using mysql command in the specified MYSQL_DB."
	echo " MYSQL_DB     The name of the MySQL database to restore into on the target machine. This script assumes the database was already created."
	echo " MYSQL_PW     The MySQL root user password to use for the restore."
	echo "Remarks:"
	echo " This script uses sudo is used to copy site files."
	echo " The USER is expected to be configured in /etc/sudoers so that sudo does not require a password."
}

die () {
	show_help
	echo >&2 "$@"
	exit 1
}

# ensure arguments specified:
DEST_HOST_SSH=$1
SOURCE_FILES=$2
SOURCE_DB=$3
MYSQL_DB=$4
MYSQL_PW=$5

[ $DEST_HOST_SSH ] || die "USER@HOST not specified!"
[ $SOURCE_FILES ] || die "SOURCE_FILES not specified!"
[ $SOURCE_DB ] || die "SOURCE_DB not specified!"
[ $MYSQL_DB ] || die "MYSQL_DB not specified!"
[ $MYSQL_PW ] || die "MYSQL_PW not specified!"

# split SSH user@host syntax into host & user:
DEST_USER=`echo $DEST_HOST_SSH | sed -E 's/^([^@]*)@.*/\1/'`
DEST_HOST=`echo $DEST_HOST_SSH | sed -E 's/^[^@]*@(.*)/\1/'`
[ $DEST_USER ] || die "USER@HOST syntax incorrect? User not found."
[ $DEST_HOST ] || die "USER@HOST syntax incorrect? Host not found."

# hardcoded values:
MYSQL_USER=root
DEST_FILES=/var/www/joomla-site
DEST_DB=~/Latest.sql

#####
# -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
# -z, --compress              compress file data during the transfer
# -h, --human-readable        output numbers in a human-readable format
# -L, --copy-links            transform symlink into referent file/dir
# -e, --rsh=COMMAND           specify the remote shell to use
#     --delete                delete extraneous files from dest dirs
OPTIONS=(-azhL --delete --stats) # NOTE: Using array syntax due to embedded quotes: http://superuser.com/questions/354361/rsync-complaining-about-missing-trailing-in-a-bash-script

echo "Uploading database backup..."
rsync "${OPTIONS[@]}" $SOURCE_DB $DEST_HOST_SSH:Latest.sql || die "rsync failed"

echo "Uploading database backup complete."
echo "Restoring database..."
# The other script already creates the db...
# echo "  creating DB..."
# ssh $DEST_HOST_SSH mysql -u$MYSQL_USER -p$MYSQL_PW mysql <<< "create database $MYSQL_DB;"; 
# echo "  creating DB complete."
echo "  restoring..."
ssh $DEST_HOST_SSH "mysql '-u$MYSQL_USER' '-p$MYSQL_PW' '$MYSQL_DB' < ~/Latest.sql"
echo "  restoring complete."
echo "Restoring database complete."

echo "Chowning site root:"
ssh $DEST_HOST_SSH "sudo -E mkdir -v $DEST_FILES; sudo -E chown -v $DEST_USER $DEST_FILES"
echo ""
echo "Uploading site files..."
rsync "${OPTIONS[@]}" $SOURCE_FILES $DEST_HOST_SSH:/var/www/joomla-site || die "rsync failed"
echo "Uploading site files complete."

