#!/bin/bash
# A UNIX / Linux shell script to backup mysql server database.
# -------------------------------------------------------------------------
# Copyright (c) 2020 Daniel Vaqueiro <dvaqueiro@boardfy.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
### SETUP MYSQL LOGIN ###
MCFGFILE='config.cnf'

### Set to 1 if you need to see progress while dumping dbs ###
VERBOSE=1
EXCLUDED_DBS='information_schema performance_schema sys'

### Setup dump local directory ###
BASEDIR='/tmp/mysql_backups'
DST_HOST='admin@storage'
DST_SSH_PORT='2222'
REMOTE_BASE_DIR='/tmp/mysql_backups'
BACKUP_RETENTION=3

### Default time format ###
TIME_FORMAT='%H_%M_%S'

#####################################
### ----[ No Editing below ]------###
#####################################
### Set bins path ###
GZIP=$(command -v gzip)
MYSQL=$(command -v mysql)
MYSQLDUMP=$(command -v mysqldump)
RM=$(command -v rm)
MKDIR=$(command -v mkdir)
MYSQLADMIN=$(command -v mysqladmin)
GREP=$(command -v grep)
SSH=$(command -v ssh)
RSYNC=$(command -v rsync)

HNAME=$(hostname)
BAKRSNROOT="$BASEDIR/$HNAME"
REMOTE_DIR="$REMOTE_BASE_DIR/$HNAME"

MYSQLDUMPFLAGS='--max-allowed-packet=128000000'
RSYNCFLAGS='-avh  --remove-source-files'

### Die on demand with message ###
die(){
    echo "$@"
    exit 999
}

### Make sure bins exists.. else die
verify_bins(){
    [ ! $GZIP ] && die "Binary for GZIP does not exists."
    [ ! $MYSQL ] && die "Binary for MYSQL does not exists."
    [ ! $MYSQLDUMP ] && die "Binary for MYSQLDUMP does not exists."
    [ ! $RM ] && die "Binary for RM does not exists."
    [ ! $MKDIR ] && die "Binary for MKDIR does not exists."
    [ ! $MYSQLADMIN ] && die "Binary for MYSQLADMIN does not exists."
    [ ! $GREP ] && die "Binary for GREP does not exists."
    [ ! $SSH ] && die "Binary for SSH does not exists."
    [ ! $RSYNC ] && die "Binary for RSYNC does not exists."
    [ $VERBOSE -eq 1 ] && echo -e "All binary verified..."
}

### Make sure we can connect to server ... else die
verify_mysql_connection(){
    $MYSQLADMIN --defaults-extra-file=$MCFGFILE ping | $GREP 'alive'>/dev/null
    [ $? -eq 0 ] || die "Error: Cannot connect to MySQL Server. Make sure username and password are set correctly in $0"
    [ $VERBOSE -eq 1 ] && echo -e "Mysql connection verified..."
}

### Make a backup ###
perform_backups(){
    local DBS="$($MYSQL --defaults-extra-file=$MCFGFILE -Bse 'show databases')"
    local db=""
    [ ! -d $BAKRSNROOT ] && ${MKDIR} -p $BAKRSNROOT
    ssh -t -t -p $DST_SSH_PORT $DST_HOST "[ ! -d $REMOTE_DIR ] && ${MKDIR} -p $REMOTE_DIR"
    ${RM} -f $BAKRSNROOT/* >/dev/null 2>&1
    [ $VERBOSE -eq 1 ] && echo -e "\n*** Dumping MySQL Database ***"
    for db in $DBS
    do
        [ $VERBOSE -eq 1 ] && echo -n "** Database> "
        if [[ "$EXCLUDED_DBS" =~ .*"$db".* ]]; then
            [ $VERBOSE -eq 1 ] && echo "$db is excluded from backup"
            continue
        fi
        local tTime=$(date +"${TIME_FORMAT}")
        local FILE="${BAKRSNROOT}/${db}.${tTime}.gz"
        [ $VERBOSE -eq 1 ] && echo "$db.."
        ${MYSQLDUMP} --defaults-extra-file=$MCFGFILE $MYSQLDUMPFLAGS $db | ${GZIP} -9 > $FILE
        [ $VERBOSE -eq 1 ] && echo -e "rsync $FILE to remote storage..\n"
        ${RSYNC} -e "ssh -p$DST_SSH_PORT" ${RSYNCFLAGS} $BAKRSNROOT/ $DST_HOST:$REMOTE_DIR
        ssh -t -t -p $DST_SSH_PORT $DST_HOST \
            "cd $REMOTE_DIR ; ls -t | grep $db | sed -e 1,"$BACKUP_RETENTION"d | tr '\n' ' ' | xargs rm -R > /dev/null 2>&1"
    done
    [ $VERBOSE -eq 1 ] && echo -e "*** Backup done [ files wrote to $BAKRSNROOT ] ***\n"
}

### main ####
verify_bins
verify_mysql_connection
perform_backups
