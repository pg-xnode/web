#!/bin/sh
if [ $# -ne 1 ]; then
	echo "usage:
$0 <output directory>"
	exit -1
fi

if [ ! -d $1 ]; then
	echo "please specify valid output directory"
	exit -1
fi

PAGE_URIS='/  /doc /download /dev'
for URI in  $PAGE_URIS
do
	if [ $URI = "/" ]; then
		OUT_FILE="index"
	else
		OUT_FILE=`echo $URI | sed -e s/\\\/// `
	fi
	OUT_FILE=$1/$OUT_FILE.html
	psql -U postgres -tAc "select page('$URI')" > $OUT_FILE
done
