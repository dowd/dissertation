#!/bin/bash




osmconvert /Users/dowd/GIS_Data/easter/users/bristol_users.o5m --csv="@version @timestamp" --csv-headline --csv-separator="," -o=/Users/dowd/GIS_Data/easter/versions/bristol_version.csv

osmconvert /Users/dowd/GIS_Data/easter/users/bristol_nodes.o5m --csv="@version @timestamp" --csv-headline --csv-separator="," -o=/Users/dowd/GIS_Data/easter/versions/bristol_all_version.csv


osmconvert /Users/dowd/GIS_Data/easter/users/cardiff_users.o5m --csv="@version @timestamp" --csv-headline --csv-separator="," -o=/Users/dowd/GIS_Data/easter/versions/cardiff_version.csv

osmconvert /Users/dowd/GIS_Data/easter/users/cardiff_nodes.o5m --csv="@version @timestamp" --csv-headline --csv-separator="," -o=/Users/dowd/GIS_Data/easter/versions/cardiff_all_version.csv


osmconvert /Users/dowd/GIS_Data/easter/users/manchester_users.o5m --csv="@version @timestamp" --csv-headline --csv-separator="," -o=/Users/dowd/GIS_Data/easter/versions/manchester_version.csv

osmconvert /Users/dowd/GIS_Data/easter/users/manchester_nodes.o5m --csv="@version @timestamp" --csv-headline --csv-separator="," -o=/Users/dowd/GIS_Data/easter/versions/manchester_all_version.csv