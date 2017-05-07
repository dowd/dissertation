library(sp)

Bristol=read.csv("data/attr/Bristol.csv",header=TRUE, stringsAsFactors = FALSE)
Cardiff=read.csv("data/attr/Cardiff.csv",header=TRUE, stringsAsFactors = FALSE)
Manchester=read.csv("data/attr/Manchester.csv",header=TRUE, stringsAsFactors = FALSE)

bristol_centre=SpatialPoints(cbind(-2.588890,51.458920))
proj4string(bristol_centre)=CRS("+init=epsg:4326")

coordinates(Bristol) <- cbind(Bristol$X.lon , Bristol$X.lat)
proj4string(Bristol)=CRS("+init=epsg:4326")
coordinates(Cardiff) <- cbind(Cardiff$X.lon , Cardiff$X.lat)
proj4string(Cardiff)=CRS("+init=epsg:4326")
coordinates(Manchester) <- cbind(Manchester$X.lon , Manchester$X.lat)
proj4string(Manchester)=CRS("+init=epsg:4326")

sidewalks=Bristol[which(Bristol$any=="sidewalk"),]

min_subset2=distm (sidewalks,bristol_centre)
test=sidewalks[subset]

test@data$any

subset=min_subset2[which(min_subset2<1000)]
