#!/bin/bash

function make_sourcepath () {
  TEMPFILE=`mktemp -u`
  find ~/Documents/brightspot -name "*\.java" > $TEMPFILE

  MYSOURCEPATH="";
  while read -r line || [[ -n "$line" ]]; do
	FILENAME=`echo $line | sed -E 's/^(.*\/).*/\1/'`
	#echo "FILENAME=$FILENAME"
	#if [[ $FILENAME != *$MYSOURCEPATH* ]]; then
	if [[ $MYSOURCEPATH != *$FILENAME* ]]; then
	  MYSOURCEPATH+=$FILENAME":"
	  echo "Adding $FILENAME"
   fi
  done < $TEMPFILE
 #Remove trailing colon from the cumulative MYPATH string
  SOURCEPATH=`echo $MYSOURCEPATH | sed -E 's/:$//'`
}


make_sourcepath
echo $SOURCEPATH

