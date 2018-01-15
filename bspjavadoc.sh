#!/bin/bash

HELPMESSAGE="\nUsage: bspjavadoc [-d /output/dir] [-m /repo/dir] Class.java\n       bspjavadoc [-d /output/dir] [-m /repo/dir] [-s package/dir] packagename\n       bspjavadoc [-d /output/dir] [-r dari|bsp]\n       bspjavadoc -h\n\n"

if [ "$#" -lt 1 ]; then

  echo -e "$HELPMESSAGE"
  exit
fi

OUTPUTDIRECTORY=/tmp/javadoc/
M2PATH=$HOME
SOURCEPATH=.
BUILDTYPE=class
REPONAME=dari

while getopts "hm:d:r:s:" opt; do
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
    r)
      REPONAME=$OPTARG
      ;;
    \?)
      echo -e "$HELPMESSAGE"
      exit
      ;;
    :) echo "missing argument for option -$OPTARG"; exit 1 ;;
  esac
done

shift $((OPTIND-1))

CLASSPATH=$M2PATH/.m2/repository/com/google/guava/guava/21.0/guava-21.0.jar:$M2PATH/.m2/repository/org/apache/commons/commons-lang3/3.2.1/commons-lang3-3.2.1.jar:$M2PATH/.m2/repository/commons-lang/commons-lang/2.4/commons-lang-2.4.jar:$M2PATH/.m2/repository/com/psddev/dari-util/3.3.92-116cf8/dari-util-3.3.92-116cf8.jar:$M2PATH/.m2/repository/javax/servlet/javax.servlet-api/3.0.1/javax.servlet-api-3.0.1.jar:$M2PATH/.m2/repository/org/slf4j/slf4j-api/1.7.6/slf4j-api-1.7.6.jar:$M2PATH/.m2/repository/javax/servlet/jsp/javax.servlet.jsp-api/2.3.1/javax.servlet.jsp-api-2.3.1.jar:$M2PATH/.m2/repository/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar:$M2PATH/.m2/repository/com/psddev/dari-asm/3.3.143-1c7d90/dari-asm-3.3.143-1c7d90.jar:$M2PATH/.m2/repository/com/google/code/findbugs/jsr305/3.0.0/jsr305-3.0.0.jar:$M2PATH/.m2/repository/com/psddev/dari-reflections/3.3.143-1c7d90/dari-reflections-3.3.143-1c7d90.jar:$M2PATH/.m2/repository/joda-time/joda-time/2.2/joda-time-2.2.jar:$M2PATH/.m2/repository/joda-time/joda-time/2.8.1/joda-time-2.8.1.jar:$M2PATH/.m2/repository/com/cronutils/cron-utils/6.0.1/cron-utils-6.0.1.jar:$M2PATH/.m2/repository/org/threeten/threetenbp/1.3.2/threetenbp-1.3.2.jar:$M2PATH/.m2/repository/org/jsoup/jsoup/1.10.3/jsoup-1.10.3.jar:$M2PATH/.m2/repository/com/fasterxml/jackson/core/jackson-core/2.9.2/jackson-core-2.9.2.jar:$M2PATH/.m2/repository/commons-fileupload/commons-fileupload/1.2.1/commons-fileupload-1.2.1.jar:$M2PATH/.m2/repository/commons-fileupload/commons-fileupload/1.2.1/commons-fileupload-1.2.1.jar:$M2PATH/.m2/repository/com/psddev/dari-db/3.3-SNAPSHOT/dari-db-3.3-SNAPSHOT.jar:$M2PATH/.m2/repository/com/psddev/cms-db/3.3-SNAPSHOT/cms-db-3.3-SNAPSHOT.jar:$M2PATH/.m2/repository/com/psddev/dari-util/3.3-SNAPSHOT/dari-util-3.3-SNAPSHOT.jar



# When getopts is over the remaining parameter @ is either a single class file or a list of packages

# Java conventions specify that package names are all lower case. We test the passed
# ending paramater to see if there are any upper-case letters. If so, assume that
# we received a class file (Something.java). Otherwise, assume that we received
# a list of packages
if [ -z "$@" ]; then
  BUILDTYPE=repo
elif [[ $@ =~ [A-Z] ]]; then
  BUILDTYPE=class
else
  BUILDTYPE=package
fi


case $BUILDTYPE in
  repo)
    echo "Building javadocs for a repo"
	 if [ "$REPONAME" == "dari" ]; then 
      TARGET="com.psddev.dari.util com.psddev.dari.aws com.psddev.dari.db com.psddev.dari.elasticsearch com.psddev.dari.h2 com.psddev.dari.mysql com.psddev.dari.sql com.psddev.dari.db.shyiko com.psddev.dari.util.sa"
      SOURCEPATH=/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/util/src/main/java/:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/aws/src/main/java/:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/db/src/main/java:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/elasticsearch/src/main/java:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/h2/src/main/java:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/mysql/src/main/java:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/sql/src/main/java:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/db/target/classes/com/psddev/dari/db/shyiko:/Users/mlautman/Documents/javadocs/objectutils/brightspot/dari/util/src/main/java/com/psddev/dari/util/sa
      WINDOWTITLE="Dari API"
      DOCTITLE="Dari API"
    else 
      TARGET="com.psddev.cms.db com.psddev.cms.hunspell com.psddev.cms.nlp com.psddev.cms.rtc com.psddev.cms.rte com.psddev.cms.tool com.psddev.cms.tool.file com.psddev.cms.tool.page com.psddev.cms.tool.page.content com.psddev.cms.tool.page.content.edit com.psddev.cms.tool.page.content.field com.psddev.cms.tool.page.user com.psddev.cms.tool.search com.psddev.cms.tool.view com.psddev.cms.tool.widget com.psddev.cms.view com.psddev.cms.view.servlet"
      SOURCEPATH=/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/:/Users/mlautman/Documents/javadocs/brightspot/cms/hunspell/src/main/java/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/nlp/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/rtc/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/rte/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/file/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/page/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/page/content/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/page/content/edit/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/page/content/field/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/page/user/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/search/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/view/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/tool/widget/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/view/:/Users/mlautman/Documents/javadocs/brightspot/cms/db/src/main/java/com/psddev/cms/view/servlet/
      WINDOWTITLE="Brightspot API"
      DOCTITLE="Brightspot API"
    fi
    ;;
  class)
    echo "Building javadocs for a class"
    WINDOWTITLE=$(echo `basename $@`)
    DOCTITLE=$(echo `basename $@`)
    TARGET=$@
    ;;
  package)
    echo "Building javadocs for a package"
    WINDOWTITLE=$@
    DOCTITLE=$@
    TARGET=$@
    ;;
esac

#echo "The target is $TARGET"
#echo "The windowtitle is $WINDOWTITLE"
#echo "The doctitle is $DOCTITLE"
#exit

javadoc -d $OUTPUTDIRECTORY -sourcepath $SOURCEPATH -protected -charset "UTF-8" -classpath $CLASSPATH -link https://docs.oracle.com/javase/8/docs/api/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-3.6/ -link https://commons.apache.org/proper/commons-lang/javadocs/api-2.6/ -Xdoclint:all -bottom 'Copyright &#169; 2017 Perfect Sense. All rights reserved.' -doctitle "$DOCTITLE" -windowtitle "$WINDOWTITLE" $TARGET

echo "Generated javadoc, if in fact it was generated, is in $OUTPUTDIRECTORY"

# The following is for a future enhancement
#ERRORCODE=$?
#
#if [ $ERRORCODE -eq 0 ]; then
#  echo "Generated javadoc in $OUTPUTDIRECTORY"
#fi
