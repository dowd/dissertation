#load libraries
library(sp)
library(osmar)
library(rgdal)

#set bounding box for use when 
bbox = corner_bbox(-8, 50, 2, 60)

#setup matrix with the names of the cities to be able to loop over
cities=c("Bristol","Cardiff")

#load csv file of types of elements
element_types=matrix(c("info_board", "bollard", "crossing", "entrance", "outdoor_seating", "waste_basket", "underpass", "bench", "bike_parking", "bus_stop", "call_booth", "lamp_post", "mailbox", "railway_station", "steps", "taxi_rank", "tree", "bus_station"))

#setup the dataframe for the results
gsv_results_df = data.frame("City"=character(),"Type"=character(),"Location"=integer(),"Points Distance"=numeric(), stringsAsFactors=FALSE)

#for loops to go through city and elements
for (city in cities) {
#read the OS csv file for the city/element type
gmm=readOGR(paste("../data/gmm/",city,".kml",sep=""),pointDropZ=TRUE)

for (element_type in element_types[,1]) {
  print(paste(city,element_type))
  
gmm_temp=gmm[which(gmm@data$Name==element_type),]

if (!nrow(gmm_temp)==0){

#read the OSM file for the city/element type
osm_temp = get_osm(bbox, osmsource_osmosis(file = paste("/Users/dowd/GIS_Data/easter/OSM_metro_extract/OS/",city,"/",element_type,".osm",sep="")))



if (!nrow(osm_temp)==0){
osm_points=as_sp(osm_temp, 'points')

for (ents in 1:nrow(gmm_temp)){
  #print(paste(ents,"out of",nrow(os_temp),"rows"))
  #set the GSV point from the ents number
  gmm_point=gmm_temp[ents,]
  #find the minimum distance for the OSM point data
  pointdistance=min(distm (osm_points,gmm_point), na.rm=TRUE)
  this_result=c(city,element_type,ents,pointdistance)
  gsv_results_df[nrow(gsv_results_df)+1,] = this_result
}

}else {
  #if no results in OSM for type then fill in with NA's
  for (ents in 1:nrow(gmm_temp)){
    this_result=c(city,element_type,ents,NA)
    gsv_results_df[nrow(gsv_results_df)+1,] = this_result
  }
}
}
}
}