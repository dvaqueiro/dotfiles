#!/bin/bash
# A UNIX / Linux shell script to create new mysql schema and user
# -------------------------------------------------------------------------
# Copyright (c) 2020 Daniel Vaqueiro <dvaqueiro@boardfy.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
### SETUP MYSQL LOGIN ###
MCFGFILE='config.cnf'

#####################################
### ----[ No Editing below ]------###
#####################################
### Set bins path ###
MYSQL=$(command -v mysql)

die(){
	echo "$@"
	exit 9
}

verify_bins(){
	[ ! $MYSQL ] && die "Binary for MYSQL does not exists. Make sure correct path is set in $0."
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
    $MYSQL --defaults-extra-file=$MCFGFILE -Bse "CREATE DATABASE IF NOT EXISTS $schema;GRANT ALL PRIVILEGES ON $schema.* TO $user@'%' IDENTIFIED BY '$password';FLUSH PRIVILEGES"
}

### main ###
verify_bins
ask_for_data
create_database
