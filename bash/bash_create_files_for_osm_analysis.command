#!/bin/bash
INPUT=/Users/dowd/Google\ Drive/GIS/Dissertation/git/dissertation/elementsall.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read element query1 query2 query3 query4|| [ -n "$element" ]
do
	query="$query1 $query2 $query3 $query4"
	echo "$element $query"

	osmfilter /Users/dowd/GIS_Data/easter/OSM_metro_extract/Cardiff.o5m --keep="$query" -o=/Users/dowd/Google\ Drive/GIS/Dissertation/git/data/OSM/Cardiff/$element.o5m


osmconvert /Users/dowd/Google\ Drive/GIS/Dissertation/git/data/OSM/Cardiff/$element.o5m  --all-to-nodes -o=/Users/dowd/Google\ Drive/GIS/Dissertation/git/data/OSM/Cardiff/$element.osm


done < $INPUT
IFS=$OLDIFS