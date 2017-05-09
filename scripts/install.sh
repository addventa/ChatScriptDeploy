#!/bin/bash

read -p "Please enter the ChatScript version to download [7.3]: " VERSION

if [ $VERSION == ""]
then
  VERSION="7.3"
fi

echo "LOGS : Install ChatScript for LINUX"

#-----------------------
# Set Global Variables |
#-----------------------
echo "LOGS : Set variables"
ChatScriptURL=https://netix.dl.sourceforge.net/project/chatscript/ChatScript-$VERSION.zip

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
checkLibrary "unzip"
checkLibrary "wget"

#----------------
# Set crontab   |
#----------------
setCrontab() {
echo "Clean, Create and Set Crontab"
CSPATH=$(pwd)
crontab -l > mycron
echo "0,5,10,15,20,25,30,35,40,45,50,55 * * * * cd $CSPATH/CS/ChatScript/BINARIES && ./LinuxChatScript64 >> cronserver.log 2>&1" >> mycron
crontab mycron
rm mycron
}

#------------------
# Set new version |
#------------------
echo "Set new version and clean old if exists !"
crontab -l | grep ./LinuxChatScript64 && rm -rf CS/ChatScript* || setCrontab
if [ -d ./CS ]
then
  cd CS
else
  mkdir CS
  cd CS
fi

#-----------------------
# Download ChatScript  |
#-----------------------
echo "LOGS : Download ChatScript version $VERSION"
downloadChatScript() {
mkdir ChatScript-$VERSION
cd ChatScript-$VERSION
wget $ChatScriptURL --no-check-certificate

echo "LOGS : Unzip folder"
unzip -q ChatScript-$VERSION.zip
chmod +x BINARIES/LinuxChatScript64
cd ..
if [ -f ChatScript ]
then
  rm ChatScript
fi
ln -s ChatScript-$VERSION ChatScript
rm ./ChatScript-$VERSION/ChatScript-$VERSION.zip
}

if [ -d ./ChatScript-$VERSION ]
then
  echo "LOGS : ChatScript-$VERSION folder already exist"
else
  echo "LOGS : Downloading ..." && downloadChatScript
fi

echo "ChatScript Installed"

#---------------------
# Authorized IP's    |
#---------------------
echo "Keep AuthorizedIP"
if [ -f authorizedIP.txt ]
then
  rm ChatScript/authorizedIP.txt
  ln -s ../authorizedIP.txt ChatScript/authorizedIP.txt
else
  mv ChatScript/authorizedIP.txt .
  ln -s ../authorizedIP.txt ChatScript/authorizedIP.txt
fi

cd ..