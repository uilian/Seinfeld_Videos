#!/bin/sh

#########################################################
# by Uilian Souza
# www.uilian.com
# A script shell created by a lazy programmer to 
# download the daily videos from www.jerryseinfeld.com 
# without the need to  remember to do that every day. 
# Hope you enjoy it! 
# Use it at your own risk.
#########################################################

BASE_NAME=VIDEOS_
EXTENSION=.TXT
# If user don't chooses any dir, the default will be the USER_HOME
DOWN_DIR=${1-~}/
DATE=$(date +%d_%m_%Y)
LIST_FILE=$DOWN_DIR$BASE_NAME$DATE$EXTENSION

# Extract the urls and file names from the webpage and 
# generates the download list of the day
wget -qO- http://www.jerryseinfeld.com  | awk '/#today/' | sed -e 's/^.*{//g' | sed -e 's/}.*$//g'| sed 's/\\//g' | sed 's/, / /g'| cut -d"," -f1,6 | cut -d"\"" -f4,8 | sed -e 's/ /\_/g' |sed -e 's/\"/.mp4 /' >  $LIST_FILE


echo
echo "* Download list was saved to "$LIST_FILE 
echo
echo "* Preparing to download the following videos: "
cat $LIST_FILE | awk '{print "   -",$1,": [",$2, "]"}'
echo
echo "* Files will be saved in "$DOWN_DIR
echo
echo "* Processing ..."
echo
cd $DOWN_DIR
# Execute the download commands
cat $LIST_FILE | awk '{print "wget -O",$1," ",$2}' | while read line; do $( echo "$line" ); done

echo "* Done!"
