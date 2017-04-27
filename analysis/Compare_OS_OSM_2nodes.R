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

#setup the dataframe for the results
os_results_df = data.frame("City"=character(),"Type"=character(),"OS_reference"=integer(),"Points Distance"=numeric(), stringsAsFactors=FALSE)


for(city in cities) {
  #LOOP TO BE ADDED - go through city and elements
  for (element_type in element_types[,1]) {
    #type=element_types[element_types$V1==element_type,7]
    print(paste(city,element_type))
    
    #read the OS csv file for the city/element type
    os_temp=read.csv(paste("../data/os_poi/",city,"/",element_type,".csv",sep=""), header=TRUE, stringsAsFactors = FALSE)
    
    #read the OSM file for the city/element type
    osm_temp = get_osm(bbox, osmsource_osmosis(file = paste("/Users/dowd/GIS_Data/easter/OSM_metro_extract/OS/",city,"/",element_type,".osm",sep="")))
    
    
    
    
    #check that the files contain rows
    if (!nrow(os_temp)==0) {
      #convert both files to spatial data frames
      coordinates(os_temp) <- cbind(os_temp$X , os_temp$Y)
      proj4string(os_temp)=CRS("+init=epsg:4326")
      osm_points=as_sp(osm_temp, 'points')
      
      #for loop to go over every row in os_temp and find nearest point in OSM data and return osmid and distance into os_temp
      
      for (ents in 1:nrow(os_temp)){
        #print(paste(ents,"out of",nrow(os_temp),"rows"))
        #set the OS point from the ents number
        os_point=os_temp[ents,]
        #find the minimum distance for the OSM point data
        pointdistance=min(distm (osm_points,os_point), na.rm=TRUE)
        this_result=c(city,element_type,os_point@data$Reference,pointdistance)
        os_results_df[nrow(os_results_df)+1,] = this_result
      }
    }
    
    
  }
}

os_results_df$Points.Distance=as.numeric(os_results_df$Points.Distance)

write.table(os_results_df, file = "export_all_points.csv", sep = ",", col.names = NA, qmethod = "double")
