#!/bin/bash

# This script updates column "name" and "emails" 
# in accordance with the task

# argument check block
if [ -z "$1" ];         # if sting empty
then
    echo "Input file must be passed as an argument!"
    exit 1 
fi

if ! [ -f $1 ] || ! [ -e $1 ];      # check if if input variable exist and is it file
then
    echo "Input file '"$1"' doesn't exist!"
    exit 1 
fi

if [[ $1 != *.csv ]];
then
    echo "Wrong file format. Must be .csv"
    exit 1
fi

sed -i -r 's/(.*".*),(.*")/\1_\2/' $1 #

awk -F, ' {

    for (i=1; i<= NF; i++) {                                                    # going for all records line
        if (NR!=1) {                                                            # if now first line with rowname
            
            if (i==3) {
                name=tolower(substr($i,0, 1))                                   # get first character symbol
                surname=tolower(substr($i,index($i, " ")+1, length($i)))        # get surname
                $i=toupper(substr($i,0, 1)) tolower(substr($i,2, index($i," ")-1)) \  
                    toupper(substr($i,index($i, " ")+1, 1)) \ 
                    tolower(substr($i,index($i, " ")+2, \ 
                    length($i)-index($i," ")+2))  # generate uppercase for first character for name and surname
            }
            if (i==5) $i= name surname  "@abc.com"                           # generate new email
            
        }
        printf $i ","
    }
    printf("\n");       #if last record in line send end line
 }'  accounts.csv > accounts_new.csv

#chek equals emails and adding location_id
tail +2 accounts_new.csv | while read line  #read file without header
do
    mail=$(echo $line | grep -oP '(?<=,)\S*@\S*\.\S{2,3}')          #get email 
    
    if  [[ "1" -ne $(grep $mail accounts_new.csv| wc -l) ]]         #check how much emails in the file   
    then
        for lid in $(grep -n $mail accounts_new.csv| cut -d , -f 1-2 ) #get number of line and location_id
        do
            lnum=$(echo $lid | cut -d : -f 1)
            id=$(echo $lid | cut -d , -f 2)
            sed -i -r "${lnum}s/(.*)@(.*)/\1${id}@\2/" accounts_new.csv #add location_id to email
        done
    fi
done

#recover data for pattern "*,*"
sed -i -r 's/(.*".*)_(.*")/\1,\2/' $1
sed -i -r 's/(.*".*)_(.*")/\1,\2/' accounts_new.csv  

