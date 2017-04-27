library(osmar)
library(plyr)
library(scales)

elements=read.csv("../data/elements/element_attr_table.csv", header=TRUE, stringsAsFactors = FALSE)

cities=c("Bristol","Cardiff","Manchester")

#uncomment to load osm files
#bbox = corner_bbox(-8, 50, 2, 60)
#src = osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Manchester.osm")
#src2=osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Cardiff.osm")
#osm_temp = get_osm(bbox, src)
#src3=osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Bristol.osm")
#osm_temp = get_osm(bbox, src)
#osm_temp_c = get_osm(bbox, src2)
#osm_temp_b = get_osm(bbox, src3)


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

number_tag=function(x) {
  if (x[3]=="*") {
    subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2]))))
    subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2]))))
  } else {
    subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2] & v==x[3]))))
    subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2] & v==x[3]))))
  }
  return(sum(subset$ways$tags$k==x[4])+sum(subset2$nodes$tags$k==x[4]))
}








  






for (city in cities) {
  osm_temp=eval(parse(text = city))

  elements$Total_OSM=apply(elements, 1, number_elements)
  elements$No_Tag=apply(elements, 1, number_tag)
  names(elements)[names(elements)=="Total_OSM"] = paste(city,"total_osm",sep="_")
  names(elements)[names(elements)=="No_Tag"] = paste(city,"no_tag",sep="_")
  
}


elements$Percent_Bristol=percent(elements$Bristol_no_tag/elements$Bristol_total_osm)
elements$Percent_Cardiff=percent(elements$Cardiff_no_tag/elements$Cardiff_total_osm)
elements$Percent_Manchester=percent(elements$Manchester_no_tag/elements$Manchester_total_osm)

write.table(elements,file="../data/results/attributes_final.csv",sep=",",col.names = NA,qmethod="double")




