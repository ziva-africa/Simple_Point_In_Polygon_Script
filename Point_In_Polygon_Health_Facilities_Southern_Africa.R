# Simple script to assign health facilities to admin boundaries - see README for more details

# Import required libraries
library(tidyverse)
library(sf)

# Import health facility data as .csv file and covert to sf object
file_loc <- '/home/ziva/Desktop/tempWD/pointInPolygonAlgorithm/testData/sa_hf_data.csv'
health_facilities <- read.csv(file_loc)

hf_sf <- health_facilities %>%
  mutate_at(vars(Lon, Lat), as.numeric) %>%
  filter(!(is.na(Lat))) %>%
  st_as_sf(
    coords = c("Lon", "Lat"),
    agr = "constant",
    crs = 4148,        # Hartebeesthoek94 / South Africa Projection
    stringsAsFactors = FALSE,
    remove = TRUE
  )

# Import admin boundaries data
file_loc <- '/home/ziva/Desktop/tempWD/pointInPolygonAlgorithm/testData/zaf_adm_sadb_ocha_20201109_SHP/zaf_admbnda_adm3_sadb_ocha_20201109.shp'
admin_boundaries <- st_read(file_loc) %>%
  st_transform(4148)

# Perform spatial join and write results as csv file
hf_admin_join <- st_join(hf_sf, admin_boundaries, join = st_within)
file_loc <- '/home/ziva/Desktop/tempWD/pointInPolygonAlgorithm/testData/hf_admin_joined.csv'
write.csv(hf_admin_join, file_loc, row.names = FALSE)