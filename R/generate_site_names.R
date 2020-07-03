#' Generate site names from geospatial layers
#'
#' @return data.table of park names
#' @export
#'
generate_site_names = function() {	

	# Column to be used to define site name	
	cols <- c("NAME")	

	# Get data from each of the geospatial layers	
	df_greenery <- get_data_from_sf(get_data_and_assign("v_greenery"))[, ..cols]	
	df_greenery$habitat_final <- "GREENERY"	

	df_islands <- get_data_from_sf(get_data_and_assign("v_islands"))[, ..cols]	
	df_islands$habitat_final <- "ISLAND"	

	parks_cols <- c(cols, "habitat")	
	df_parks_all <- get_data_from_sf(get_data_and_assign("v_parks_all"))[, ..parks_cols]	
	df_parks_all$habitat_final <- paste0("PARKS (ALL) -- ", df$habitat)	
	df_parks_all$habitat <- NULL	

	df_parks_nat_res <- get_data_from_sf(get_data_and_assign("v_parks_nat_res"))[, ..cols]	
	df_parks_nat_res$habitat_final <- "PARKS (NATURE RESERVE)"	

	df_planning_area <- get_data_from_sf(get_data_and_assign("v_planning_areas"))[, ..cols]	
	df_planning_area$habitat_final <- "PLANNING AREA"	

	# Combine these datasets	
	df_habitat_sites <- 	
		rbind(df_greenery, df_islands, df_parks_all, df_parks_nat_res, df_planning_area)	

	# Create the habitat_IUCN variable	
	df_habitat_sites <- match_habitat_to_broad_iucn_habitat(df_habitat_sites, "habitat_final")	

	df_habitat_sites	

} 