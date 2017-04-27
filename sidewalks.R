library(sp)
library(osmar)

bristol_box=corner_bbox(-2.714444,51.39899,-2.511022,51.5430)
src = osmsource_api()


bbox = corner_bbox(-8, 50, 2, 60)
src <- osmsource_osmosis(file = "/Users/dowd/GIS_Data/easter/OSM_metro_extract/sidewalks/Bristol_highways.osm")
osm_temp = get_osm(bbox, src)

summary(osm_temp)
nrow(osm_temp$ways$attrs)

sum(osm_temp$ways$tags$k=="sidewalk")


100*(939/18172)
