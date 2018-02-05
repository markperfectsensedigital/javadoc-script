#!/bin/bash

# make_classpath creates the classpath that javadocs needs to search for other classes.
# The function opens a war file using jar tvf and searches for all file names ending with 'jar'. 
# Each line from the war file is written to an external file. Below is an example line.
#
# 520331 Thu Dec 21 16:53:00 EST 2017 WEB-INF/lib/core.jar
#
# Next, each line in the temporary file is read through sed, and all characters stripped so that we have only the base
# file name. Referring to the previous example, the base file name is core.
# We use find to find a jar file using that core file name inside the maven repository. Using the previous
# example, one such result is
#
# .m2/repository//com/google/zxing/core/2.2/core-2.2.jar 
#
# We append all those file names to a MYPATH variable, and
# subsequently return assign them to a CLASSPATH variable.
#
function make_classpath () {
  printf "Assembling CLASSPATH..."
  TEMPFILE=`mktemp -u`
  jar tvf ~/Documents/tutorials/getposition/brightspot-tutorial/init/target/tutorial-init-1.0-SNAPSHOT.war | grep "jar$" > $TEMPFILE

  MYPATH="";
  while read -r line || [[ -n "$line" ]]; do
	FILENAME=`echo $line | sed -E 's/^.*lib\/(.*)\.jar$/\1/'`
	#echo $FILENAME
	NEWFILE=`find ~/.m2/repository -name "$FILENAME*jar" -print -quit`
	MYPATH+=$NEWFILE":"
  done < $TEMPFILE

# Remove trailing colon from the cumulative MYPATH string
  CLASSPATH=`echo $MYPATH | sed -E 's/:$//'`
  #echo "Classpath:"
  #echo $CLASSPATH
  printf "finished\n"
}


# make_sourcepath creates the sourcepath that javadocs needs when building for
# a package or when using -subpackages.
#
# The function starts with a root directory of a brightspot projecdt ~/Documents/brightspot.
# In that root directory, find all files ending with ".java" and output that list to
# a temporary file. Below is an example line:
#
# ./watch/src/main/java/com/psddev/watch/WatchTool.java
#
# Next, each line in the temporary file is read through sed, to find the directory containing the current line
# (which is the directory containing the current package).
# Referring to the previous example, the directory containing the file is 
#
# ./watch/src/main/java/
#
# We add that found directory to a string MYSOURCEPATH. At each line we extract the directory name and ensure
# that it doesn't already exist in MYSOURCEPATH before concatenating it--thereby avoiding duplicate directories
# in the final source path. 
#
# We subsequently return the entire MYSOURCEPATH string as a SOURCEPATH variable.
function make_sourcepath () {
  printf "Assembling SOURCEPATH..."
  TEMPFILE=`mktemp -u`
  find $1 -name "*\.java" > $TEMPFILE

  MYSOURCEPATH="";
  while read -r line || [[ -n "$line" ]]; do
  # echo $line
	#FILENAME=`echo $line | sed -E 's/^(.*\/).*/\1/'`
	FILENAME=`echo $line | sed -E 's/^(.*src\/.*\/java).*$/\1/'`
#	echo "FILENAME=$FILENAME"
	if [[ $MYSOURCEPATH != *$FILENAME* ]]; then
	  MYSOURCEPATH+=$FILENAME":"
   fi
  done < $TEMPFILE
 #Remove trailing colon from the cumulative MYSOURCEPATH string
  SOURCEPATH=`echo $MYSOURCEPATH | sed -E 's/:$//'`
  #echo "MYSOURCEPATH"
  #echo $MYSOURCEPATH
  #echo "SOURCEPATH"
  #echo $SOURCEPATH
  printf "finished\n"
}


function make_packagelist () {
  printf "Assembling PACKAGELIST..."
  TEMPFILEPACKAGE=`mktemp -u`
  find $1 -name "*\.java" > $TEMPFILEPACKAGE

  MYPACKAGELIST="";
  while read -r line || [[ -n "$line" ]]; do
   #echo $line
	PACKAGENAMESLASHES=`echo $line | sed -E 's/^.*src\/.*\/java\/(.*)\/.*\.java$/\1/'`
   
   # The following test ensures we do not add package names that the previous
   # sed did not process, in which case it returns the original line from the list of
   # all java files. Each of those lines starts with the user's $HOME string. If
   # the current line includes the $HOME string, then continue the loop.
	if [[ $PACKAGENAMESLASHES == *$HOME* ]]; then
      continue
   fi
   #echo $PACKAGENAMESLASHES
   PACKAGENAME=`echo $PACKAGENAMESLASHES | sed -E 's/\//./g'`
#	echo "FILENAME=$FILENAME"

	if [[ $MYPACKAGELIST != *$PACKAGENAME* ]]; then
	  MYPACKAGELIST+=$PACKAGENAME" "
   fi
  done < $TEMPFILEPACKAGE
 #Remove trailing space from the cumulative MYPACKAGELIST string
  PACKAGELIST=`echo $MYPACKAGELIST | sed -E 's/ $//'`
  # echo $PACKAGELIST
  printf "finished\n"
}

HELPMESSAGE="\nUsage: bspjavadoc [-d /output/dir] [-m /repo/dir] Class.java\n       bspjavadoc [-d /output/dir] [-m /repo/dir] [-s /source/base/dir] packagenames|all\n       bspjavadoc -h\n\nExamples: bspjavadoc cms/db/src/main/java/com/psddev/cms/db/ToolUi.java\n          bspjavadoc -s /path/to/bsp-install-root com.psddev.cms.db\n          bspjavadoc -s /path/to/bsp-install-root all\n"

if [ "$#" -lt 1 ]; then
  echo -e "$HELPMESSAGE"
  exit
fi

OUTPUTDIRECTORY=/tmp/javadoc/
M2PATH=$HOME
BASESOURCEPATH=.
BUILDTYPE=class
REPONAME=dari

while getopts "hm:d:s:" opt; do
  case $opt in 
    m)
      echo "Found here"
      M2PATH=$OPTARG
      ;;
    h)
      echo -e "$HELPMESSAGE"
      exit
      ;;
    d)
      OUTPUTDIRECTORY=$OPTARG
      ;;
    s)
      BASESOURCEPATH=$OPTARG
      if [ $BASESOURCEPATH == "." ]; then
        BASESOURCEPATH=$PWD
      fi
      ;;
    \?)
      echo -e "$HELPMESSAGE"
      exit
      ;;
    :) echo "missing argument for option -$OPTARG"; exit 1 ;;
  esac
done

shift $((OPTIND-1))

# When getopts is over the remaining parameter @ is either a single class file or a list of packages

# Java conventions specify that package names are all lower case. We test the passed
# ending paramater to see if there are any upper-case letters. If so, assume that
# we received a class file (Something.java). Otherwise, assume that we received
# a list of packages

#echo "The BASESOURCEPATH is $BASESOURCEPATH"

make_classpath

#echo "The classpath is..."
#echo $CLASSPATH
#exit



if [[ $@ =~ [A-Z] ]]; then
  BUILDTYPE=class
else
  BUILDTYPE=package
fi

# If passed all as the final parameter, then we want to build the entire
# documentation set for all packages.
if [ $@ == "all" ]; then
  make_packagelist $BASESOURCEPATH
else
  PACKAGELIST=$@
fi


case $BUILDTYPE in
  class)
    echo "Building javadocs for a class"
    WINDOWTITLE=$(echo `basename $@`)
    DOCTITLE=$(echo `basename $@`)
    TARGET=$@
    ;;
  package)
    echo "Building javadocs for one or more packages"
    make_sourcepath $BASESOURCEPATH
    WINDOWTITLE=$@
    DOCTITLE=$@
    TARGET=$PACKAGELIST
    ;;
esac

#echo "The target is $TARGET"
#echo "The windowtitle is $WINDOWTITLE"
#echo "The doctitle is $DOCTITLE"
#echo "The sourcepath is $SOURCEPATH"
#exit

javadoc -d $OUTPUTDIRECTORY -sourcepath $SOURCEPATH -protected -charset "UTF-8" -classpath $CLASSPATH -link https://docs.oracle.com/javase/8/docs/api/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-3.6/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-2.6/ -Xdoclint:all -bottom 'Copyright &#169; 2017 Perfect Sense. All rights reserved.' -doctitle "$DOCTITLE" -windowtitle "$WINDOWTITLE" $TARGET

echo "Generated javadoc, if in fact it was generated, is in $OUTPUTDIRECTORY"

# The following is for a future enhancement
#ERRORCODE=$?
#
#if [ $ERRORCODE -eq 0 ]; then
#  echo "Generated javadoc in $OUTPUTDIRECTORY"
#fi
