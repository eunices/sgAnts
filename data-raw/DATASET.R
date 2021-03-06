## code to prepare `DATASET` dataset goes here


# Libraries
library(sf)
library(data.table)

# Folders
setwd("C:/_dev/msc/sg-ant-red-list")
folder_data_root = "data/geo_processed/"
folder_data = paste0(folder_data_root, "final/")
folder_test = paste0(folder_data_root, "2020-05-29-random-pts/test/") # test data




# Vectors
g_islands = paste0(folder_data, "islands.gpkg")
g_parks_nat_res = paste0(folder_data, "parks-nature-reserves.gpkg")
g_parks_all = paste0(folder_data, "parks-all.gpkg")
g_greenery = paste0(folder_data, "greenery.gpkg")
g_planning_areas = paste0(folder_data, "planning-areas.gpkg")



v_islands = st_read(g_islands)
v_parks_nat_res = st_read(g_parks_nat_res)
v_parks_all = st_read(g_parks_all)
v_greenery = st_read(g_greenery)
v_planning_areas = st_read(g_planning_areas)

# Rename and subset columns
v_islands = v_islands[, c("NAME", "geom")]
v_parks_nat_res = v_parks_nat_res[, c("NAME", "geom")]

v_parks_all$habitat = ifelse(v_parks_all$TYPE == "FRINGING FOREST" & !is.na(v_parks_all$TYPE),
                             "NATURE RESERVE (AND ADJACENT FORESTS)",
                             as.character(v_parks_all$habitat))
v_parks_all = v_parks_all[, c("NAME", "geom", "habitat", "AREA_SQ_M", 
                              "prop_veg_canopy_unmanaged", "prop_veg_canopy",
                              "prop_veg_no_canopy", "prop_veg",
                              "prop_veg_no_canopy_of_veg", "mangrove",
                              "veg_canopy_unmanaged")]

v_greenery = v_greenery[, c("NAME", "geom", "AREA_SQ_M")]
v_planning_areas = v_planning_areas[, c("NAME", "geom", "OBJECTID")]

setwd("C:/_dev/msc/sgAnts")
usethis::use_data(v_islands, overwrite = TRUE)
usethis::use_data(v_parks_nat_res, overwrite = TRUE)
usethis::use_data(v_parks_all, overwrite = TRUE)
usethis::use_data(v_greenery, overwrite = TRUE)
usethis::use_data(v_planning_areas, overwrite = TRUE)





sgAnts_test_data = paste0(folder_test, "test-points.csv")
sg_ants_test = fread(sgAnts_test_data)
sg_ants_test$id = 1:dim(sg_ants_test)[1]

setwd("C:/_dev/msc/sgAnts")
usethis::use_data(sg_ants_test, overwrite = TRUE)
