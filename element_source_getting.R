library(osmar)
library(plyr)
library(scales)

elements=read.csv("../data/results/element2_table.csv", header=TRUE, stringsAsFactors = FALSE)

cities=c("Bristol","Cardiff","Manchester")

bbox = corner_bbox(-8, 50, 2, 60)
srcm = osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Manchester.osm")
srcc=osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Cardiff.osm")
#osm_temp = get_osm(bbox, src)
srcb=osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Bristol.osm")
#Manchester = get_osm(bbox, srcm)
#Cardiff = get_osm(bbox, srcc)
#Bristol = get_osm(bbox, srcb)


number_elements=function(x) {
  if (x[3]=="*") {
  subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2]))))
  subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2]))))
} else {
  subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2] & v==x[3]))))
  subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2] & v==x[3]))))
}
  return(nrow(subset$ways$attrs)+nrow(subset2$nodes$attrs))
}

number_source=function(x) {
  if (x[3]=="*") {
    subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2]))))
    subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2]))))
  } else {
    subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2] & v==x[3]))))
    subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2] & v==x[3]))))
  }
  return(sum(subset$ways$tags$k=="source")+sum(subset2$nodes$tags$k=="source"))
}


for (city in cities) {
osm_temp=eval(parse(text = city))

elements$Total_OSM=apply(elements, 1, number_elements)
elements$No_Source=apply(elements, 1, number_source)
names(elements)[names(elements)=="Total_OSM"] = paste(city,"total_osm",sep="_")
names(elements)[names(elements)=="No_Source"] = paste(city,"no_source",sep="_")

}

elements2=ddply(elements,~element_name,summarize,Bristol_total_osm=sum(Bristol_total_osm),Bristol_no_source=sum(Bristol_no_source),Cardiff_total_osm=sum(Cardiff_total_osm),Cardiff_no_source=sum(Cardiff_no_source),Manchester_total_osm=sum(Manchester_total_osm),Manchester_no_source=sum(Manchester_no_source))

elements2$Percent_Bristol=percent(elements2$Bristol_no_source/elements2$Bristol_total_osm)
elements2$Percent_Cardiff=percent(elements2$Cardiff_no_source/elements2$Cardiff_total_osm)
elements2$Percent_Manchester=percent(elements2$Manchester_no_source/elements2$Manchester_total_osm)

write.table(elements2, file="../data/results/elements_source.csv",sep=",",col.names = NA,qmethod="double")
