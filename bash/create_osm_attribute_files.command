#!/bin/bash


osmfilter /Users/dowd/GIS_Data/easter/OSM_metro_extract/Manchester.o5m --keep="crossing=* sidewalk=* stepcount=* surface=* incline=*" -o=/Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.o5m

osmconvert /Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.o5m -o=/Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.osm

osmconvert /Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.o5m --csv-headline --csv="@id @lon @lat crossing step_count surface incline highway" --all-to-nodes --csv-separator="," -o=/Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.csv