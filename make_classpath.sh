#!/bin/bash


function make_classpath () {
TEMPFILE=`mktemp -u`
jar tvf ~/Documents/tutorials/getposition/brightspot-tutorial/init/target/tutorial-init-1.0-SNAPSHOT.war | grep "jar$" > $TEMPFILE

MYPATH="";
while read -r line || [[ -n "$line" ]]; do
   #sed -E 's/^.*lib\/(.*)\.jar$/\1/' <$TEMPFILE >/tmp/aslkdfj.txt
   #FILENAME=`sed -E 's/^.*lib\/(.*)\.jar$/\1/' <$line`
	#echo $line
	#echo $line | sed -E 's/^.*lib\/(.*)\.jar$/\1/'
	FILENAME=`echo $line | sed -E 's/^.*lib\/(.*)\.jar$/\1/'`
	#echo $FILENAME
	NEWFILE=`find ~/.m2/repository -name "$FILENAME*jar" -print -quit`
	#echo $NEWFILE
	MYPATH+=$NEWFILE":"
    #echo "searching for file: $line"
#	 find ~/.m2/repository name = "$line*jar"
done < $TEMPFILE
#echo "Final classpath"
#echo $MYPATH
#echo "-----------------------------------"

CLASSPATH=`echo $MYPATH | sed -E 's/:$//'`
#echo $CLASSPATH
}

make_classpath
echo "All done, ehre it is"
echo $CLASSPATH

