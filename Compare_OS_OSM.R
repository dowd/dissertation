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
  if (!(is.na(distance_matrix))){
    min_dist=min(distance_matrix)
    ref=which.min(distance_matrix)
    osmid=osmpoints@data[ref,1]
    result=c(min_dist,osmid)
    }else{
      result=c(NA,NA)
    }
  return(result)
}

#function to find distances between a point and multiple lines and returns a matrix of those distances
min2lines=function(os_point,osmlines) {
  distance_matrix=matrix()
  for (line in 1:nrow(osm_lines)) {
    tryCatch({ distance_matrix[line]=dist2Line(os_point,osmlines[line,])[1] }, error=function(e){distance_matrix[line]=NA})}
  if (is.na(distance_matrix)) {result=c(NA,NA)
    }else{
      min_dist=min(distance_matrix,na.rm=TRUE)
      ref=which.min(distance_matrix)
      osmid=osmlines@data[ref,1]
      result=c(min_dist,osmid)}
  return(result)
}

#LOOP TO BE ADDED - go through city and elements
for (element_type in element_types[,1]) {
  #type=element_types[element_types$V1==element_type,7]
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
    osm_points=as_sp(osm_temp, 'points')
    osm_lines=as_sp(osm_temp,'lines')
    osm_polygons=as_sp(osm_temp,'polygons')
    if(is.null(osm_points)) {point_file=0}else{point_file=1}
    if(is.null(osm_lines)) {line_file=0}else{line_file=1}
    if(is.null(osm_polygons)) {polygon_file=0}else{polygon_file=1}
    
    #for loop to go over every row in os_temp and find nearest point/line/polygon in OSM data and return osmid and distance into os_temp
    for (ents in 1:nrow(os_temp)){
      #points
      os_point=os_temp[ents,]
      if (point_file==1){result_points=min2points(os_point,osm_points)}else{result_points=c(NA,NA)}
      #lines
      if (line_file==1){result_lines=min2lines(os_point,osm_lines)}else{result_lines=c(NA,NA)}
      #polygons
      if (polygon_file==1){result_polygons=min2lines(os_point,osm_polygons)}else{result_polygons=c(NA,NA)}
      #put all of the results into one data frame
      result_all=data.frame(result_points,result_lines,result_polygons)
      #put the minimum distance and osmid into os_temp spatial data frame
      distance=min(result_all[1,],na.rm=TRUE)
      os_temp@data$osm_id[ents]=result_all[2,which(result_all[1,]==distance)]
      os_temp@data$osm_dist[ents]=distance
      os_temp_df=as.data.frame(os_temp)
      os_all = rbind(os_temp_df, if(exists("os_all")) os_all)
    }
  }
}







View(review)

#testing variables - only used to test thing working while creating project!!
city="Cardiff"
element_type="underpass"
element_type="taxi_rank"
ents=1
