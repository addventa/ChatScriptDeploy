#!/bin/bash

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 [repository_name]"
  exit 1
fi

#------------------------
# Verify Libraries      |
#------------------------
echo "LOGS : Check libraries"
checkLibrary() {
which $1 && VAR=1 || VAR=0
if [ $VAR = 1 ]
then
  echo "LOGS: $1 found !"
else
  echo "ERROR : $1 not found !" && exit 1
fi
}
checkLibrary "wget"
checkLibrary "curl"
checkLibrary "jq"
checkLibrary "unzip"

#-------------
# Version    |
#-------------
read -p "Please enter the version to download [latest]: " VERSION

if [ $VERSION == ""]
then
  VERSION="latest"
fi

#--------------------------
# OAUTH Authentification  |
#--------------------------
read -p "Please enter your OAuth_Token : " TOKEN
echo

#-----------------------
# Set Global Variables |
#-----------------------
PROJECTNAME=$1
ZIP="$PROJECTNAME-$VERSION.zip"
REPO="addventa/$PROJECTNAME"
GITHUB="https://api.github.com"
CSPATH="$(pwd)/CS"
BOTPATH="$(pwd)/BOTS"

#-------------------
# Download Release |
#-------------------
echo "Download $PROJECTNAME Release from GitHub"
if [ -d ./BOTS ]
then
  cd BOTS
else
  mkdir BOTS
  cd BOTS
fi

if [ -d ./$PROJECTNAME ]
then
  cd $PROJECTNAME
else
  mkdir $PROJECTNAME
  cd $PROJECTNAME
  cp -r $CSPATH/ChatScript/LOGS .
  cp -r $CSPATH/ChatScript/TOPIC .
  cp -r $CSPATH/ChatScript/USERS .
fi

alias errcho='>&2 echo'
gh_curl() {
  curl -H "Authorization: token $TOKEN" \
       -H "Accept: application/vnd.github.v3.raw" \
       $@
}
if [ "$VERSION" = "latest" ]
then
  parser='.[0].assets | map(select(.name | contains("zip")))[0].name'
  name=`gh_curl -s $GITHUB/repos/$REPO/releases | jq -c "$parser"`
  ZIP=`echo $name | sed 's/\"//g'`
  BOT=`echo $ZIP | sed 's/\.zip//g'`
  parser='.[0].assets | map(select(.name | contains("zip")))[0].id'
else
  parser=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$ZIP\"))[0].id"
fi
asset_id=`gh_curl -s "$GITHUB/repos/$REPO/releases" | jq "$parser"`
if [ $asset_id = "null" ]
then
  errcho "ERROR: version not found $VERSION"
  exit 1
fi
wget --auth-no-challenge --header='Accept:application/octet-stream' \
  https://$TOKEN:@api.github.com/repos/$REPO/releases/assets/$asset_id \
  -O $ZIP  || { exit >&2 "Download of $PROJECTNAME failed"; exit 1; }

echo "Unzip File"
unzip -q $ZIP
rm $ZIP

#---------------------
# Turn OFF Cron Job  |
#---------------------
echo "Turn OFF Cron Job"
sudo service crond stop

#-----------------------------
# Kill the process of server |
#-----------------------------
echo "Kill ChatBot"
kill $(ps aux | grep '[L]inuxChatScript64' | awk '{print $2}')

#----------------------------
# Compilation of the server |
#---------------------------
echo "Launch the bot in server mode"
cd $CSPATH/ChatScript/BINARIES
./LinuxChatScript64 local build1=$BOTPATH/$PROJECTNAME/files1.txt topic=$BOTPATH/$PROJECTNAME/TOPIC 
nohup ./LinuxChatScript64 topic=$BOTPATH/$PROJECTNAME/TOPIC users=$BOTPATH/$PROJECTNAME/USERS logs=$BOTPATH/$PROJECTNAME/LOGS >> cronserver.log 2>&1 &

#----------------
# Set crontab   |
#----------------
echo "Clean, Create and Set Crontab"
crontab -r
crontab -l > mycron
echo "0,5,10,15,20,25,30,35,40,45,50,55 * * * * cd $CSPATH/CS/ChatScript/BINARIES && ./LinuxChatScript64 topic=$BOTPATH/$PROJECTNAME/TOPIC users=$BOTPATH/$PROJECTNAME/USERS logs=$BOTPATH/$PROJECTNAME/LOGS >> cronserver.log 2>&1" >> mycron
crontab mycron
rm mycron

#-----------------------
# Delete Private Data  |
#-----------------------
echo "Delete private data"
cd $BOTPATH/$PROJECTNAME
rm -r BOTDATA
rm files1.txt