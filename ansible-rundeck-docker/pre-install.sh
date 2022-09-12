#!/bin/bash

# this script creates random passwords
# and updates the .env file

# create a new environment file

# random password for Database connection
RANDOMPASSWORD=`date +%s | sha256sum | base64 | head -c 32`

# the hostname which we can use in order to access rundeck
# from the outside.
# we set this to the hostname of the docker host
GRAILS_HOST_NAME=`hostname`

(cat >.env) <<EOF
# a random password for database connection
RUNDECK_DATABASE_USERNAME=rundeck
RUNDECK_DATABASE_PASSWORD=$RANDOMPASSWORD
RUNDECK_DATABASE_DRIVER=org.mariadb.jdbc.Driver
RUNDECK_GRAILS_URL=http://${GRAILS_HOST_NAME}:4440
RUNDECK_DATABASE_URL=jdbc:mysql://mariadb/rundeck?autoReconnect=true&useSSL=false
MARIADB_DATABASE=rundeck
MYSQL_DATABASE=rundeck
MARIADB_RANDOM_ROOT_PASSWORD=yes
MYSQL_RANDOM_ROOT_PASSWORD=yes
#MARIADB_MYSQL_LOCALHOST_USER=rundeck
#MARIADB_MYSQL_LOCALHOST_GRANTS=all
MARIADB_USER=rundeck
MARIADB_PASSWORD=$RANDOMPASSWORD
MYSQL_USER=rundeck
MYSQL_PASSWORD=$RANDOMPASSWORD
VSCODE_PASSWORD=onemarcfifty
EOF

RANDOMPASSWORD="nothing here"
