library(plyr)

gsv_results_df$Points.Distance=as.numeric(gsv_results_df$Points.Distance)

results=ddply(gsv_results_df,~City+Type,summarise,'Mean Distance'=mean(Points.Distance),'Total in OS'=sum(!is.na(City)),'No. under 20m'=sum(Points.Distance<20),'Percentage in OSM under 20m'=round((sum(Points.Distance<20))/(sum(!is.na(City)))*100,digits=2),'Mean distance under 20m'=mean(Points.Distance[Points.Distance<20]),'Standard Deviation distance under 20m'=sd(Points.Distance[Points.Distance<20]),'No. under 50m'=sum(Points.Distance<20),'Percentage in OSM under 50m'=round((sum(Points.Distance<50))/(sum(!is.na(City)))*100,digits=2),'Mean distance under 50m'=mean(Points.Distance[Points.Distance<50]),'Standard Deviation under 50m'=sd(Points.Distance[Points.Distance<50]))


write.table(results, file = "/Users/dowd/Google Drive/GIS/Dissertation/code/results/GSV_OSM_Results_analysis.csv", sep = ",", col.names = NA, qmethod = "double")
