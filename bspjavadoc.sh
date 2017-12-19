#!/bin/bash

HELPMESSAGE="\nUsage: bspjavadoc [-d /output/dir] [-m /repo/dir] Class.java\n       bspjavadoc [-d /output/dir] [-m /repo/dir] [-s package/dir] packagename\n       bspjavadoc -h\n\n"

if [ "$#" -lt 1 ]; then

  echo -e "$HELPMESSAGE"
  exit
fi

OUTPUTDIRECTORY=/tmp/javadoc/
M2PATH=$HOME
SOURCEPATH=.

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
      SOURCEPATH=$OPTARG
      ;;
    :) echo "missing argument for option -$OPTARG"; exit 1 ;;
  esac
done

shift $((OPTIND-1))

# When getopts is over the remaining parameter @ is either a single class file or a list of packages

PACKAGEBUILD=true

# Java conventions specify that package names are all lower case. We test the passed
# ending paramater to see if there are any upper-case letters. If so, assume that
# we received a class file (Something.java). Otherwise, assume that we received
# a list of packages

if [[ $@ =~ [A-Z] ]]; then
  PACKAGEBUILD=false
fi


if [ $PACKAGEBUILD = false ] ; then # Generate javadoc for single file
	echo "Building for a single file"
	javadoc -d $OUTPUTDIRECTORY -public -charset "UTF-8" -classpath $M2PATH/.m2/repository/com/google/guava/guava/21.0/guava-21.0.jar:$M2PATH/.m2/repository/org/apache/commons/commons-lang3/3.2.1/commons-lang3-3.2.1.jar:$M2PATH/.m2/repository/com/psddev/dari-util/3.3.92-116cf8/dari-util-3.3.92-116cf8.jar:/tmp/commons-lang-2.6/commons-lang-2.6.jar -link https://docs.oracle.com/javase/8/docs/api/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-3.6/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-2.6/ $@
else # Generate javadoc for packages
	echo "Building for a package"
	javadoc -d $OUTPUTDIRECTORY -sourcepath $SOURCEPATH -public -charset "UTF-8" -classpath $M2PATH/.m2/repository/com/google/guava/guava/21.0/guava-21.0.jar:$M2PATH/.m2/repository/org/apache/commons/commons-lang3/3.2.1/commons-lang3-3.2.1.jar:$M2PATH/.m2/repository/com/psddev/dari-util/3.3.92-116cf8/dari-util-3.3.92-116cf8.jar:/tmp/commons-lang-2.6/commons-lang-2.6.jar -link https://docs.oracle.com/javase/8/docs/api/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-3.6/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-2.6/ $@
fi


echo "Generated javadoc, if in fact it was generated, is in $OUTPUTDIRECTORY"

# The following is for a future enhancement
#ERRORCODE=$?
#
#if [ $ERRORCODE -eq 0 ]; then
#  echo "Generated javadoc in $OUTPUTDIRECTORY"
#fi

