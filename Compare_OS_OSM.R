#load libraries
library(sp)
library(osmar)

#set bounding box for use when 
bbox = corner_bbox(-8, 50, 2, 60)
osm_types=read.csv("/Users/dowd/Google Drive/GIS/Dissertation/code/types_OS.csv", header=FALSE, stringsAsFactors = FALSE)

The Cat Sat On THe Mat