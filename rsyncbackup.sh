#!/bin/bash

DATE=`date +%y%m%d-%H%M%S`
#echo $DATE

HOSTNAME=`hostname`
#echo $HOSTNAME

# should external defined via local config
RSB_SET_NAME=$HOSTNAME
RSB_SRC_BASE=$HOME
RSB_DEST_DIR="/data/backup/$RSB_SET_NAME"
RSB_DEST_HOST=""
#RSB_RSYNC_PRE="caffeinate -s"
RSB_RSYNC_PRE=""
# end def

RSB_CONF_DIR="$HOME/.rsb"

# Source the local config
. $RSB_CONF_DIR/config.sh

# run remote or local?
if [ $RSB_DEST_HOST ]
  then
    RSB_DEST_BASE="$RSB_DEST_HOST:$RSB_DEST_DIR"
    RSB_CMD_PRE="ssh $RSB_DEST_HOST"
  else
    RSB_DEST_BASE="$RSB_DEST_DIR"
    RSB_CMD_PRE=""
  fi

RSB_DEST_LAST="$RSB_DEST_DIR/last"
RSB_DEST_ARCH_DIR="$RSB_DEST_DIR/archive/$DATE"
RSB_DEST="$RSB_DEST_BASE/archive/$DATE"
RSB_INCL_FILE="$RSB_CONF_DIR/includes.txt"

if $RSB_CMD_PRE test -a $RSB_DEST_LAST
  then
    RSB_LINK_DEST_OPT="--link-dest=$RSB_DEST_LAST"
  fi

if [ -a $RSB_INCL_FILE ]
  then
    RSB_INCL_OPT="--include-from=$RSB_INCL_FILE"
  fi

$RSB_CMD_PRE mkdir -p "$RSB_DEST_DIR/archive"

echo "DEST: $RSB_DEST"

$RSB_RSYNC_PRE rsync -aH --delete $RSB_INCL_OPT $RSB_LINK_DEST_OPT "$RSB_SRC_BASE" "$RSB_DEST"

$RSB_CMD_PRE rm -f $RSB_DEST_LAST
$RSB_CMD_PRE ln -s $RSB_DEST_ARCH_DIR $RSB_DEST_LAST
