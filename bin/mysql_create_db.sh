#!/bin/bash
# A UNIX / Linux shell script to create new mysql schema and user
# -------------------------------------------------------------------------
# Copyright (c) 2020 Daniel Vaqueiro <dvaqueiro@boardfy.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
### SETUP MYSQL LOGIN ###
USER='mysqluser'
PASS='mysqlpassword'
HOST="127.0.0.1"

### Set bins path ###
MYSQL=/usr/bin/mysql

#####################################
### ----[ No Editing below ]------###
#####################################
die(){
	echo "$@"
	exit 9
}

verify_bins(){
	[ ! -x $MYSQL ] && die "File $MYSQL does not exists. Make sure correct path is set in $0."
}

ask_for_data() {
    read -p 'New database name: ' schema
    read -p 'New user name: ' user
    read -s -p 'Password: ' password
    echo
    read -s -p 'Password (again): ' password_retry
    echo
    while [ "$password" != "$password_retry" ];
    do
        echo
        echo "Please try again"
        read -s -p "Password: " password
        echo
        read -s -p "Password (again): " password_retry
        echo
    done
}

create_database() {
    $MYSQL -u $USER -h $HOST -p$PASS -Bse "CREATE DATABASE IF NOT EXISTS $schema;GRANT ALL PRIVILEGES ON $schema.* TO $user@'%' IDENTIFIED BY '$password';FLUSH PRIVILEGES"
}

### main ###
verify_bins
ask_for_data
create_database
