library(plyr)
library(dplyr)
library(jsonlite)

cities=c("bristol","cardiff","manchester")


results = data.frame("X.und"=character(),"City Nodes"=numeric(),"Relevant Nodes"=numeric(),"city"=character(), stringsAsFactors=FALSE)

for (city in cities) {

city_data = read.csv(paste("/Users/dowd/GIS_Data/easter/users/",city,"_users.csv",sep=""),header=TRUE)
city_all_data = read.csv(paste("/Users/dowd/GIS_Data/easter/users/",city,"_all_users.csv",sep=""),header=TRUE)


sum_city=ddply(city_data,~X.uid,summarise,"Relevant Nodes"=sum(!is.na(X.uid)))
sum_city_all=ddply(city_all_data,~X.uid,summarise,"City Nodes"=sum(!is.na(X.uid)))


all=left_join(sum_city_all, sum_city)
all$city=city

results=rbind(results,all)
}




for(x in 1:nrow(results)) {
  
  tryCatch((results$total_nodes[x]=(fromJSON(URLencode(paste("https://osm-comments-api.mapbox.com/api/v1/users/id/",results$X.uid[x],sep=""))))$num_changes), error=function(e) paste("Error:", x))
}


write.table(results, file = "../data/results/user_results.csv", sep = ",", col.names = NA, qmethod = "double")
