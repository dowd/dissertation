#!/bin/bash


osmfilter /Users/dowd/GIS_Data/easter/OSM_metro_extract/Manchester.o5m --keep="highway=crossing highway=steps sidewalk=*" -o=/Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.o5m

osmconvert /Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.o5m -o=/Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.osm

osmconvert /Users/dowd/GIS_Data/easter/attr_files/Manchester_attr.o5m --csv-headline --csv="@id @lon @lat name crossing step_count surface incline highway step sidewalk" --all-to-nodes --csv-separator="," -o=/Users/dowd/GIS_Data/easter/attr_files/Manchester_attr_with.csv