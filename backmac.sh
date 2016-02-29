#!/bin/bash

DATE=`date +%y%m%d-%H%M%S`
echo $DATE

#RSB_DEST=pi@bb-8/data/ke
RSB_DEST=/Users/ke/bak

caffeinate -s rsync -aH --delete --include-from=$HOME/.rsb/include.txt --link-dest=$RSB_DEST/last /Users/insync/test $RSB_DEST/$DATE

rm -f $RSB_DEST/last
ln -s $RSB_DEST/$DATE $RSB_DEST/last
