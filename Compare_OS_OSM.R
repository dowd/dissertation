#load libraries
library(sp)
library(osmar)

#set bounding box for use when 
bbox = corner_bbox(-8, 50, 2, 60)

#setup matrix with the names of the cities to be able to loop over
cities=c("Bristol","Cardiff","Manchester")

#load csv file of types of elements
osm_types=read.csv("elements.csv", header=FALSE, stringsAsFactors = FALSE)

#function to find distances between a point and multiple lines and returns a matrix of those distances

distance2lines=function(os_point,osm_lines) {
  distance_matrix=matrix()
  for (line in 1:nrow(osm_lines)) {
      distance_matrix[line]=dist2Line(os_point,osm_lines[line,])[1]}
  return(distance_matrix)
}

os_temp=read.csv(paste("../data/os_poi/Cardiff/",osm_type,".csv",sep=""), header=TRUE, stringsAsFactors = FALSE)
osm_temp = get_osm(bbox, osmsource_osmosis(file = paste("../OSM/Cardiff_",osm_type,".osm",sep="")))
