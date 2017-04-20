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
min2lines=function(os_point,osm_lines) {
  distance_matrix=matrix()
  for (line in 1:nrow(osm_lines)) {
    tryCatch({ distance_matrix[line]=dist2Line(os_point,osm_lines[line,])[1] }, 
             error=function(e){distance_matrix[line]=9999})
  }
   return(distance_matrix)}


for(city in cities) {
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
    
    #for loop to go over every row in os_temp and find nearest point/line/polygon in OSM data and return osmid and distance into os_temp
    
    for (ents in 1:nrow(os_temp)){
      #print(paste(ents,"out of",nrow(os_temp),"rows"))
      #set the OS point from the ents number
      os_point=os_temp[ents,]
      #find the minimum distance for the OSM point data
      pointdistance=min(distm (osm_points,os_point), na.rm=TRUE)
      #find the minimum distance for the OSM line data
      if(is.null(osm_lines)){linedistance=NA
      }else{
      linematrix=min2lines(os_point,osm_lines)
      linedistance=ifelse(all(is.na(linematrix)),NA,min(linematrix,na.rm=TRUE))}
      #find the minimum distance for the OSM polygon data
      if(is.null(osm_polygons)){polygondistance=NA
      }else{
      polygonmatrix=min2lines(os_point,osm_polygons)
      polygondistance=ifelse(all(is.na(polygonmatrix)),NA,min(polygonmatrix,na.rm=TRUE))}
      this_result=c("City"=city,"Type"=element_type,"OS_reference"=os_point@data$Reference,"Points Distance"=pointdistance,"Lines Distance"=linedistance,"Polygons Distance"=polygondistance)
      os_results_df[nrow(os_results_df)+1,] = this_result
    }
  }
}
}


write.table(os_results_df, file = "export_all.csv", sep = ",", col.names = NA, qmethod = "double")




#testing variables - only used to test thing working while creating project!!
city="Cardiff"
element_type="underpass"
element_type="taxi_rank"
ents=1
