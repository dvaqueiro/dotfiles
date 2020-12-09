#!/bin/bash
# A UNIX / Linux shell script to backup mysql server database.
# -------------------------------------------------------------------------
# Copyright (c) 2020 Daniel Vaqueiro <dvaqueiro@boardfy.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
#####################################
### ----[ No Editing below ]------###
#####################################
### SETUP MYSQL LOGIN ###
MCFGFILE='config.cnf'
### Set to 1 if you need to see progress while dumping dbs ###
VERBOSE=0
EXCLUDED_DBS='information_schema performance_schema sys'
### Setup dump local directory ###
BAKRSNROOT='/tmp/mysql_backups'
DST_HOST='user@storage.somedomain.com'
DST_SSH_PORT='22'
REMOTE_DIR='/tmp/mysql_backups'
BACKUP_RETENTION=3
### Default time format ###
TIME_FORMAT='%Y_%m_%d-%H_%M_%S'

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


MYSQLDUMPFLAGS='--max-allowed-packet=128000000'
RSYNCFLAGS='-avh  --remove-source-files'

### Die on demand with message ###
die(){
    echo "[Fatal error] $@"
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
    [ $VERBOSE -eq 1 ] && echo -e "\n*** Dumping MySQL Database ***"
    for db in $DBS
    do
        [ $VERBOSE -eq 1 ] && echo -n "** Database> "
        if [[ "$EXCLUDED_DBS" =~ .*"$db".* ]]; then
            [ $VERBOSE -eq 1 ] && echo "$db is excluded from backup"
            continue
        fi
        local tTime=$(date +"${TIME_FORMAT}")
        local FILE="${BAKRSNROOT}/${db}-${tTime}.gz"
        [ $VERBOSE -eq 1 ] && echo "$db.."
        ${MYSQLDUMP} --defaults-extra-file=$MCFGFILE $MYSQLDUMPFLAGS $db | ${GZIP} -9 > $FILE
        [ $VERBOSE -eq 1 ] && echo -e "rsync $FILE to remote storage..\n"
        ${RSYNC} -e "ssh -p$DST_SSH_PORT" ${RSYNCFLAGS} $BAKRSNROOT/ $DST_HOST:$REMOTE_DIR
        ssh -t -t -p $DST_SSH_PORT $DST_HOST \
            "cd $REMOTE_DIR ; ls -t | grep $db | sed -e 1,"$BACKUP_RETENTION"d | tr '\n' ' ' | xargs rm -R > /dev/null 2>&1"
    done
    [ $VERBOSE -eq 1 ] && echo -e "*** Backup done [ files transfered to $REMOTE_DIR ] ***\n"
}

usage()
{
  echo -e "Usage: $0 [options...]"
  echo -e " -h\t\tShow this message and exit."
  echo -e " -l <path>\tLocal path to temporary dump. Default:/tmp/mysql_backups"
  echo -e " -t <path>\tRemote path to store backup. Default:/tmp/mysql_backups"
  echo -e " -d <host>\tRemote host. Default:user@storage.somedomain.com"
  echo -e " -p <port>\tRemote ssh host port. Default:22"
  echo -e " -o <format>\tTime format. Default:%H_%M_%S"
  echo -e " -f <file>\tMysql connection config file. Default:config.cnf"
  echo -e " -r <number>\tBackup retention. Default:3"
  echo -e " -e <dbs>\tExcluded databases. Default:information_schema performance_schema sys"
  echo -e " -v\t\tVerbose."
  exit 2
}

show_config() {
    [ $VERBOSE -eq 1 ] && echo "MCFGFILE: $MCFGFILE"
    [ $VERBOSE -eq 1 ] && echo "VERBOSE: $VERBOSE"
    [ $VERBOSE -eq 1 ] && echo "EXCLUDED_DBS: $EXCLUDED_DBS"
    [ $VERBOSE -eq 1 ] && echo "BASEDIR: $BAKRSNROOT"
    [ $VERBOSE -eq 1 ] && echo "DST_HOST: $DST_HOST"
    [ $VERBOSE -eq 1 ] && echo "DST_SSH_PORT: $DST_SSH_PORT"
    [ $VERBOSE -eq 1 ] && echo "REMOTE_DIR: $REMOTE_DIR"
    [ $VERBOSE -eq 1 ] && echo "BACKUP_RETENTION: $BACKUP_RETENTION"
    [ $VERBOSE -eq 1 ] && echo "TIME_FORMAT: $TIME_FORMAT"
}

while getopts 'vhl:r:d:p:t:f:r:e:' c
do
    case $c in
        v) VERBOSE=1 ;;
        l) BAKRSNROOT=$OPTARG ;;
        t) REMOTE_DIR=$OPTARG ;;
        d) DST_HOST=$OPTARG ;;
        p) DST_SSH_PORT=$OPTARG ;;
        o) TIME_FORMAT=$OPTARG ;;
        f) MCFGFILE=$OPTARG ;;
        r) BACKUP_RETENTION=$OPTARG ;;
        e) EXCLUDED_DBS=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done

### main ####
verify_bins
verify_mysql_connection
# show_config
perform_backups
