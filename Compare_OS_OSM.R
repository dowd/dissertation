#load libraries
library(sp)
library(osmar)

#set bounding box for use when 
bbox = corner_bbox(-8, 50, 2, 60)

#setup matrix with the names of the cities to be able to loop over
cities=c("Bristol","Cardiff","Manchester")

#load csv file of types of elements
element_types=read.csv("elements.csv", header=FALSE, stringsAsFactors = FALSE)
element_types=element_types[!element_types$V7=="",]

#function to find distances between a point and multiple lines and returns a matrix of those distances
min2points=function(os_point,osmpoints) {
  distance_matrix=distm (osm_points,os_point)
  result=c(min(distance_matrix),which.min(distance_matrix))
  return(result)
}


#function to find distances between a point and multiple lines and returns a matrix of those distances
min2lines=function(os_point,osmlines) {
  distance_matrix=matrix()
  for (line in 1:nrow(osm_lines)) {
    tryCatch({ distance_matrix[line]=dist2Line(os_point,osmlines[line,])[1] }, error=function(e){distance_matrix[line]=NA})}
  result=c(min(distance_matrix, na.rm=TRUE),which.min(distance_matrix))
  return(result)
}

#LOOP TO BE ADDED - go through city and elements
for (element_type in element_types[,1]) {
  type=element_types[element_types$V1==element_type,7]
  print(paste(city,element_type))
    
  #read the OS csv file for the city/element type
  os_temp=read.csv(paste("../data/os_poi/",city,"/",element_type,".csv",sep=""), header=TRUE, stringsAsFactors = FALSE)
  
  #read the OSM file for the city/element type
  osm_temp = get_osm(bbox, osmsource_osmosis(file = paste("/Users/dowd/GIS_Data/easter/OSM_metro_extract/OS/",city,"_",element_type,".osm",sep="")))
  
  #check that the files contain rows
  if (!nrow(os_temp)==0 & (!((dim(osm_temp)[1])+(dim(osm_temp)[2]))==0)) {
    #convert both files to spatial data frames
    coordinates(os_temp) <- cbind(os_temp$X , os_temp$Y)
    proj4string(os_temp)=CRS("+init=epsg:4326")
    os_point=os_temp[ents,]
    tryCatch({
      osm_points=as_sp(osm_temp, 'points')
      result_points=min2points(os_point,osm_points)
      }, warning=function(e){result_points=c(NA,NA)})
    tryCatch({
      osm_lines=as_sp(osm_temp,'lines')
      result_lines=min2lines(os_point,osm_lines)
      print("lines")
      }, warning=function(e){result_lines=c(NA,NA)
      print("lines warning")})
    tryCatch({
      osm_polygons=as_sp(osm_temp,'polygons')
      result_polygons=min2lines(os_point,osm_polygons)
      print("polygons")
      }, warning=function(e){result_polygons=c(NA,NA)
      print("polygons warning")})
    
    line_matrix=distance2lines(os_temp[1,],osm_lines)
    
    
}
}



osm_lines=as_sp(osm_temp,'lines')
result_lines=min2lines(os_point,osm_lines)
print("lines")

#testing variables - only used to test thing working while creating project!!
city="Cardiff"
element_type="underpass"
element_type="bus_station"
