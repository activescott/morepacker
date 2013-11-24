#!/bin/bash
##########
# Installs everything necessary on an ubuntu box for Joomla and 
# prepares a joomla site in the user's at ~/joomla-site.
# RUN this on the machine that is to run joomla!!
##########

function show_help() {
	echo "provision_joomla.sh MYSQL_ROOTPW MYSQL_USER MYSQL_PW MYSQL_DB"
	echo "    MYSQL_ROOTPW: Password to use for the mysql root user."
	echo "    MYSQL_USER:   The name of the user to provision in mysql used for joomla."
	echo "    MYSQL_PW:     catThe password for the mysql user."
	echo "    MYSQL_DB:     The name of the database to create in mysql that joomla will use."
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

require_sudo

MYSQL_ROOTPW=$1
MYSQL_USER=$2
MYSQL_PW=$3
MYSQL_DB=$4

[ $MYSQL_ROOTPW ] || die "Specify mysql root password with MYSQL_ROOTPW environment variable!"
[ $MYSQL_USER ] || die "Specify mysql user with MYSQL_USER environment variable!"
[ $MYSQL_PW ] || die "Specify mysql password with MYSQL_PW environment variable!"
[ $MYSQL_DB ] || die "Specify mysql database to create/use with MYSQL_DB environment variable!"

# get the script's current directory: 
MYDIR="$( dirname "$0" )"  # "$( cd "$( dirname "$0" )" && pwd )"
echo "Script executing from \"$MYDIR\""

[ -f "$MYDIR/joomla-apache-config.conf" ] || die "Ensure that joomla-apache-config.conf is in the same directory as this script!"

apt-get update

# DEBIAN_FRONTEND used to prevent mysql prompts, from http://snowulf.com/2008/12/04/truly-non-interactive-unattended-apt-get-install/ to 
export DEBIAN_FRONTEND=noninteractive

# debconf-set-selections tips from http://www.thisprogrammingthing.com/2013/getting-started-with-vagrant/ & http://blog.cadena-it.com/linux-tips-how-to/unattendedsilent-lamp-installation-on-ubuntu/ & http://serverfault.com/questions/322400/install-mysql-server-and-set-password-from-the-command-line
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOTPW"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOTPW"

apt-get -yq install mysql-server apache2 mysql-server php5 php5-mysql libapache2-mod-php5 php5-gd

# Configure mysql:
if [[ !$MYSQL_USER ]] && [[ !$MYSQL_PW ]] && [[ !MYSQL_DB ]]; then
	echo "Creating MySQL user..."
	echo "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PW'" | mysql -uroot -p"$MYSQL_ROOTPW"
	echo "Creating MySQL user complete."
	echo "Creating MySQL database..."
	echo "CREATE DATABASE $MYSQL_DB" | mysql -uroot -p"$MYSQL_ROOTPW"
	echo "Creating MySQL database complete."
	echo "Granting user perms to MySQL database..."
	echo "GRANT ALL ON $MYSQL_DB.* TO '$MYSQL_USER'@'localhost'" | mysql -uroot -p"$MYSQL_ROOTPW"
	echo "flush privileges" | mysql -uroot -p"$MYSQL_ROOTPW"
	echo "Granting user perms to MySQL database complete."
	
	# RESTORE DB FROM SQL:
	if [ -f "joomla-db.sql" ];
	then
		mysql -uroot -p"$MYSQL_ROOTPW" $MYSQL_DB < joomla-db.sql
	else
		echo "Expected joomla-db.sql to be in the same directory as this script to restore the data from. "
		echo " SQL not found so database was not restored."
	fi
else
	echo "MYSQL_USER, MYSQL_PW, or MYSQL_DB not specified, so skipping MYSQL configuration."
fi

# Enable's apache's mod_rewrite:
a2enmod rewrite

# Create the site's dir: 
mkdir /var/www/joomla-site
# Configure the site in apache according to https://help.ubuntu.com/12.04/serverguide/httpd.html
cp $MYDIR/joomla-apache-config.conf /etc/apache2/sites-available/
ln -s /etc/apache2/sites-available/joomla-apache-config.conf /etc/apache2/sites-enabled/joomla-apache-config.conf 

# restart apache
service apache2 restart
