library(plyr)
library(dplyr)
library(scales)


#import files for city
manchester_all=read.csv("/Users/dowd/GIS_Data/easter/versions/manchester_all_version.csv", header=TRUE, stringsAsFactors = FALSE)
bristol_all=read.csv("/Users/dowd/GIS_Data/easter/versions/bristol_all_version.csv", header=TRUE, stringsAsFactors = FALSE)
cardiff_all=read.csv("/Users/dowd/GIS_Data/easter/versions/cardiff_all_version.csv", header=TRUE, stringsAsFactors = FALSE)

#import files for relevant
manchester=read.csv("/Users/dowd/GIS_Data/easter/versions/manchester_version.csv", header=TRUE, stringsAsFactors = FALSE)
bristol=read.csv("/Users/dowd/GIS_Data/easter/versions/bristol_version.csv", header=TRUE, stringsAsFactors = FALSE)
cardiff=read.csv("/Users/dowd/GIS_Data/easter/versions/cardiff_version.csv", header=TRUE, stringsAsFactors = FALSE)


#add city column to the dataframes
manchester$city="Manchester"
bristol$city="Bristol"
cardiff$city="Cardiff"
manchester_all$city="Manchester"
bristol_all$city="Bristol"
cardiff_all$city="Cardiff"

#combine the data frames into two dataframes
city=rbind(manchester,bristol)
city=rbind(city,cardiff)
city_all=rbind(manchester_all,bristol_all)
city_all=rbind(city_all,cardiff_all)

#get the timestamp column into a date and the change to number of days since 15/04/17
city$X.timestamp=strptime(city$X.timestamp,format='%Y-%m-%d')
mydate = strptime('2017-04-15',format='%Y-%m-%d')
city$X.timestamp=round(as.numeric(mydate-city$X.timestamp),digits=0)
city_all$X.timestamp=strptime(city_all$X.timestamp,format='%Y-%m-%d')
mydate = strptime('2017-04-15',format='%Y-%m-%d')
city_all$X.timestamp=round(as.numeric(mydate-city_all$X.timestamp),digits=0)

all_summ=ddply(city_all,~city,summarise,
               "No. of elements"=sum(!is.na(X.version)),
               "Max version No."=max(X.version),
               "Mean version No."=round(mean(X.version),digits=2),
               "SD version No."=round(sd(X.version),digits=2),
               "Percentage with over 5 edits"=percent((sum(X.version>=5)/(sum(!is.na(X.version))))),
               "Mean days since last edit"=round(mean(X.timestamp),digits=2),
               "SD days since last edit"=round(sd(X.timestamp),digits=2),
               "% of elements edited within the last year"=percent((sum(X.timestamp<=365))/sum(!is.na(X.version))),
               "% of elements last edited 1-4 years ago"=percent((sum(X.timestamp<=1460&X.timestamp>365))/sum(!is.na(X.version))),
               "% of elements last edited over 4 yr ago"=percent((sum(X.timestamp>1460))/sum(!is.na(X.version)))
               )

relevant_summ=ddply(city,~city,summarise,
               "No. of elements"=sum(!is.na(X.version)),
               "Max version No."=max(X.version),
               "Mean version No."=round(mean(X.version),digits=2),
               "SD version No."=round(sd(X.version),digits=2),
               "Percentage with over 5 edits"=percent((sum(X.version>=5)/(sum(!is.na(X.version))))),
               "Mean days since last edit"=round(mean(X.timestamp),digits=2),
               "SD days since last edit"=round(sd(X.timestamp),digits=2),
               "% of elements edited within the last year"=percent((sum(X.timestamp<=365))/sum(!is.na(X.version))),
               "% of elements last edited 1-4 years ago"=percent((sum(X.timestamp<=1460&X.timestamp>365))/sum(!is.na(X.version))),
               "% of elements last edited over 4 yr ago"=percent((sum(X.timestamp>1460))/sum(!is.na(X.version)))
)


write.table(all_summ, file = "/Users/dowd/Google Drive/GIS/Dissertation/git/data/results/version_all_results.csv", sep = ",", col.names = NA, qmethod = "double")

write.table(relevant_summ, file = "/Users/dowd/Google Drive/GIS/Dissertation/git/data/results/version_relevant_results.csv", sep = ",", col.names = NA, qmethod = "double")



write.table(city_all, file = "/Users/dowd/Google Drive/GIS/Dissertation/git/data/results/version_city_all.csv", sep = ",", col.names = NA, qmethod = "double")

write.table(city, file = "/Users/dowd/Google Drive/GIS/Dissertation/git/data/results/version_city.csv", sep = ",", col.names = NA, qmethod = "double")
