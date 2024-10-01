#!/bin/bash

# Author           : s193633@student.pg.edu.pl
# Created On       : Thu 22 Dec 2022 13:35
# Last Modified By : s193633@student.pg.edu.pl
# Last Modified On : Tue 23 Jan 2023 10:35
# Version          : 1.0
#
# Description      : this script allows an user to merge several pdf files into one
#
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more
# details or contact the Free Software Foundation for a copy)

#VARIABLES 
RESULT="pdftk"                            # used to merge pdf files
NAME=".pdf"                               # used to store the name of new merged pdf file
PDFTK=`pdftk --version`                   # variable that allows to check if user have downloaded pdftk extension in the past


#FUNCTIONS

# creating the content of the command
MERGINGPROCESS(){                         
   for (( c=1; c<=$FILESAMOUNT; c++))
   do
      TEMP=$(echo $FILE | cut -d "|" -f $c)
      if [[ $TEMP != *".pdf" ]];
      then
         `zenity --warning \
         --text="One of the selected files is not a pdf"`
         exit
      fi
      RESULT="$RESULT $TEMP"
   done 
   RESULT="$RESULT cat output $NAME"
} 

# naming the new merged file
FILENAME(){                             
   NAME="`zenity --forms --title="Merging pdf files" \
   --separator="," \
   --add-entry="Name of the file:"`$NAME"
   EXIST=`find ~/Desktop -name $NAME`
   while [[ -n "$EXIST" ]];
   do
      NAME="`zenity --forms --title="A file with this name already exists" \
   --separator="," \
   --add-entry="Change the name of the file"`.pdf"
   EXIST=`find ~/Desktop -name $NAME`
   done
}

# options ("-h" for help and "-v" for version)
while getopts hvf:q OPT; do               
   case $OPT in
      h) echo -e "Available options:\n   h: print this help message\n   v: print a version of this script\n"
         echo "PDF MERGING is a bash script, that merges pdf files into a new one and moves it to Desktop"
         echo "pdftk is required and if you don't have this extension, you will be asked to download"
         exit;;
      v) echo "Version :            1.0"
         echo "Created on :         22 Dec 2022"
         echo "Last modified on:    23 Jan 2023"
         exit;;
      *) echo "Unknown option"
         exit;;
esac done

if [[ $PDFTK == *"command not found"* ]];
then
   DECISION=`zenity --info --title 'PDFTK installation' \
      --text 'You need to have pdftk extension, if you want to use this script.\n\nDo you want to install pdftk?' \
      --ok-label NO \
      --extra-button YES`
   if [[ $DECISION == "YES"* ]]; 
   then
      eval "sudo apt-get install pdftk"
   else
      exit
   fi
fi
FILE=`zenity --file-selection --multiple --title="Select a File"`    #choosing what pdf files user want to merge
if [[ $FILE ]];
then
   FILENAME
else
   `zenity --warning \
         --text="No files selected"`  #when the user doesn't choose any of the pdf files
   exit
fi

FILESAMOUNT=$(echo $FILE | grep -o -i Users | wc -l)
MERGINGPROCESS
eval "$RESULT"
eval "mv $NAME ~/Desktop" 