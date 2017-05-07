library(osmar)
library(sp)
library(data.table)

elements=read.csv("data/elements/element_attr_table.csv", header=TRUE, stringsAsFactors = FALSE)

bristol_centre=SpatialPoints(cbind(-2.588890,51.458920))
proj4string(bristol_centre)=CRS("+init=epsg:4326")


key="highway"
value="steps"
attr="step_count"
  #if value is * use:
    subset=subset(Bristol, way_ids = find(Bristol, way(tags(k==key))))
    subset2=subset(Bristol, node_ids = find(Bristol, node(tags(k==key))))
  #else use:
    subset=subset(Bristol, way_ids = find(Bristol, way(tags(k==key & v==value))))
    subset2=subset(Bristol, node_ids = find(Bristol, node(tags(k==key & v==value))))
    subset=subset(subset,way_ids=find(subset,way(tags(k==attr))))
    subset2=subset(subset2,node_ids=find(subset2,node(tags(k==attr))))
   
    #min_subset2=distm (subset,bristol_centre)
    
    subset$ways$attrs$id[1]
    subset$nodes$attrs$
    
    subset$nodes=subset2$nodes
    
    subset$nodes$tags
    
   
    

    
     way=find(Bristol, way(tags(k==key & v==value)))
    node=find(Bristol, node(tags(k==key & v==value)))
    way_node=c(way,node)
    
    subsety=(subset & subset2)

    subset
    subset2
        
  subsety
  