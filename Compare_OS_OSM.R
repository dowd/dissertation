#load libraries
library(sp)
library(osmar)

#set bounding box for use when 
bbox = corner_bbox(-8, 50, 2, 60)

#setup matrix with the names of the cities to be able to loop over
cities=c("Bristol","Cardiff","Manchester")

#load csv file of types of elements
element_types=read.csv("elements.csv", header=FALSE, stringsAsFactors = FALSE)

#function to find distances between a point and multiple lines and returns a matrix of those distances
distance2lines=function(os_point,osm_lines) {
  distance_matrix=matrix()
  for (line in 1:nrow(osm_lines)) {
      distance_matrix[line]=dist2Line(os_point,osm_lines[line,])[1]}
  return(distance_matrix)
}

#LOOP TO BE ADDED - go through city and elements

#read the OS csv file for the city/element type
os_temp=read.csv(paste("../data/os_poi/",city,"/",element_type,".csv",sep=""), header=TRUE, stringsAsFactors = FALSE)

#read the OSM file for the city/element type
osm_temp = get_osm(bbox, osmsource_osmosis(file = paste("/Users/dowd/GIS_Data/easter/OSM_metro_extract/OS/",city,"_",element_type,".osm",sep="")))

#check that the files contain rows
if (nrow(os_temp)==0 & nrow(osm_temp)==0) {
#convert both files to spatial data frames
coordinates(os_temp) <- cbind(os_temp$X , os_temp$Y)
proj4string(os_temp)=CRS("+init=epsg:4326")
osm_points=as_sp(osm_temp, 'points')
osm_lines=as_sp(osm_temp,'lines')
osm_polygons=as_sp(osm_temp,'polygons')




}

result=distance2lines(os_temp[1,],osm_temp)

osm_temp


#testing variables - only used to test thing working while creating project!!
city="Cardiff"
element_type="underpass"