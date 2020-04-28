#!/bin/sh

liste=`find $1 | grep -i 'demo.ipynb'`

BINDER="https://mybinder.org/v2/gh/yg42/iptutorials/master?filepath="

for mydir in $liste; do
	#statements
	#echo $mydir
	name=`echo $mydir | sed "s/\.\///"`
	name2=`echo $name | sed "s/\//%2F/g"`

        echo $BINDER$name2

done
