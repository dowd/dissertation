library(sp)
library(osmar)

elements=read.csv("../data/results/element_attr_table.csv", header=TRUE, stringsAsFactors = FALSE)

bbox = corner_bbox(-8, 50, 2, 60)
src = osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Manchester.osm")
src2=osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Cardiff.osm")
#osm_temp = get_osm(bbox, src)
src3=osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/Bristol.osm")
#osm_temp = get_osm(bbox, src)
osm_temp_c = get_osm(bbox, src2)
osm_temp_b = get_osm(bbox, src3)

summary(osm_temp)
nrow(osm_temp$ways$attrs)

subset=subset(osm_temp, node_ids = find(osm_temp, node(tags(k=="amenity" & v=="waste_basket"))))


test=osm_temp$ways$tags$k=="highway" & osm_temp$ways$tags$v=="steps"

sum(osm_temp$relations$tags$k=="source")

nrow(osm_temp$nodes$attrs)


sum(subset$nodes$tags$k=="source")

subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k=="tunnel"))))
nrow(subset$ways)

subset

get_attribute_count = function(x, output) {
  element_name = x[1]
  type=x[2]
  key = x[3]
  value = x[4]
  if (type=="way") {
    if (value=="*") {
      subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==key))))
    } else {
  subset=subset(osm_temp, way_ids = find(osm_temp, way(tags(k==key & v==value))))
  }
  total=nrow(subset$ways$attrs)
  sauce=sum(subset$ways$tags$k=="source")
  } else {
    if (value=="*") {
      subset=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==key))))
    } else {
      subset=subset(osm_temp, node_ids = find(osm_temp, node(tags(k==key & v==value))))
    }
    total=nrow(subset$nodes$attrs)
    sauce=sum(subset$nodes$tags$k=="source")
  }
  
  if (!(x[5]=="")) {
    a=sum(subset$nodes$tags$k==x[5])
    b=sum(subset$ways$tags$k==x[5])
    attr_count=a+b
  }else{attr_count=NA}
  if (!(x[6]=="")) {
    a=sum(subset$nodes$tags$k==x[6])
    b=sum(subset$ways$tags$k==x[6])
    attr_count2=a+b
  }else{attr_count2=NA}
  if (!(x[7]=="")) {
    a=sum(subset$nodes$tags$k==x[7])
    b=sum(subset$ways$tags$k==x[7])
    attr_count3=a+b
  }else{attr_count3=NA}
  
 
    print(paste(element_name, type,key,value,total,sauce,x[5],attr_count,x[6],attr_count2,x[7],attr_count3, sep=","))
    cat(paste("Manchester",element_name, type, key,value,total,sauce,x[5],attr_count,x[6],attr_count2,x[7],attr_count3, sep=","), file= output, append = T, fill = T)
  
}

apply(elements, 1, get_attribute_count, output = '../data/test/Manchester_final.csv')








