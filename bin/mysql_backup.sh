#!/bin/bash
# A UNIX / Linux shell script to backup mysql server database using rsnapshot utility.
# -------------------------------------------------------------------------
# Copyright (c) 2007 Vivek Gite <vivek@nixcraft.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Tested under RHEL / Debian / CentOS / FreeBSD oses
# Must be Installed on remote MySQL Server
# -------------------------------------------------------------------------
# Last update: Sun Jul 5 2009 : Added mysql ping support and binary checking
# -------------------------------------------------------------------------
### SETUP MYSQL LOGIN ###
MUSER='root'
MPASS='root'
MHOST="127.0.0.1"

### Set to 1 if you need to see progress while dumping dbs ###
VERBOSE=1

### Set bins path ###
GZIP=/bin/gzip
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
RM=/bin/rm
MKDIR=/bin/mkdir
MYSQLADMIN=/usr/bin/mysqladmin
GREP=/bin/grep

### Setup dump directory ###
BAKRSNROOT=/tmp/mysql_backups

#####################################
### ----[ No Editing below ]------###
#####################################
### Default time format ###
TIME_FORMAT='%H_%M_%S%P'

### Make a backup ###
backup_mysql_rsnapshot(){
        local DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
        local db="";
        [ ! -d $BAKRSNROOT ] && ${MKDIR} -p $BAKRSNROOT
        ${RM} -f $BAKRSNROOT/* >/dev/null 2>&1
	[ $VERBOSE -eq 1 ] && echo "*** Dumping MySQL Database ***"
	[ $VERBOSE -eq 1 ] && echo -n "Database> "
        for db in $DBS
        do
                local tTime=$(date +"${TIME_FORMAT}")
                local FILE="${BAKRSNROOT}/${db}.${tTime}.gz"
		[ $VERBOSE -eq 1 ] && echo -n "$db.."
                ${MYSQLDUMP} -u ${MUSER} -h ${MHOST} -p${MPASS} $db | ${GZIP} -9 > $FILE
        done
		[ $VERBOSE -eq 1 ] && echo ""
		[ $VERBOSE -eq 1 ] && echo "*** Backup done [ files wrote to $BAKRSNROOT] ***"
}

### Die on demand with message ###
die(){
	echo "$@"
	exit 999
}

### Make sure bins exists.. else die
verify_bins(){
	[ ! -x $GZIP ] && die "File $GZIP does not exists. Make sure correct path is set in $0."
	[ ! -x $MYSQL ] && die "File $MYSQL does not exists. Make sure correct path is set in $0."
	[ ! -x $MYSQLDUMP ] && die "File $MYSQLDUMP does not exists. Make sure correct path is set in $0."
	[ ! -x $RM ] && die "File $RM does not exists. Make sure correct path is set in $0."
	[ ! -x $MKDIR ] && die "File $MKDIR does not exists. Make sure correct path is set in $0."
	[ ! -x $MYSQLADMIN ] && die "File $MYSQLADMIN does not exists. Make sure correct path is set in $0."
	[ ! -x $GREP ] && die "File $GREP does not exists. Make sure correct path is set in $0."
}

### Make sure we can connect to server ... else die
verify_mysql_connection(){
	$MYSQLADMIN  -u $MUSER -h $MHOST -p$MPASS ping | $GREP 'alive'>/dev/null
	[ $? -eq 0 ] || die "Error: Cannot connect to MySQL Server. Make sure username and password are set correctly in $0"
}

### main ####
verify_bins
verify_mysql_connection
backup_mysql_rsnapshot
