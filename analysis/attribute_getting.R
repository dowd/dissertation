library(osmar)

elements=read.csv("data/elements/element_attr_table.csv", header=TRUE, stringsAsFactors = FALSE)

cities=c("Bristol","Cardiff","Manchester")

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

number_attr=function(x) {
  if (x[3]=="*") {
    subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2]))))
    subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2]))))
  } else {
    subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==x[2] & v==x[3]))))
    subset2=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==x[2] & v==x[3]))))
  }
  
  #subset=subset(subset,way_ids=find(subset,way(tags(k==x[4]))))
  #subset2=subset(subset2,node_ids=find(subset2,node(tags(k==x[4]))))
  
  return(sum(subset$ways$tags$k==x[4])+sum(subset2$nodes$tags$k==x[4]))
}



elements$Total_OSM=apply(elements, 1, number_elements)
elements$No_Attr=apply(elements, 1, number_attr)




for (city in cities) {
  osm_temp=eval(parse(text = city))
  
  elements$Total_OSM=apply(elements, 1, number_elements)
  elements$No_Attr=apply(elements, 1, number_attr)
  names(elements)[names(elements)=="Total_OSM"] = paste(city,"total_osm",sep="_")
  names(elements)[names(elements)=="No_Attr"] = paste(city,"no_attributes",sep="_")
  
}
