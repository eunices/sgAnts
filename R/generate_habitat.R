
#' Generate the site name and corresponding habitat category for each species record/row
#' 
#' Generate the site name and corresponding habitat category (habitat_final) based on a series of
#' spatial joins from point data (typically latitude and longitude, though this can be changed) to 
#' the geospatial vectors found in the package.
#'
#' @param df_species Data (data.table) containing individual species records. 
#' Should minimally have specimen identifier, species identity, verbatim locality and/or 
#' latitude and longitude, collection date and specimen type (worker, queen, male/ female alate).
#' @param identifier_columns These are a group of identifier columns, used for easy reference
#' and joins to other derived datasets. Should include columns analgous to "id", "species", 
#' "type" (i.e. whether alate, worker etc). 
#' @param coord_columns The columns names of the "X" and "Y" coordinates respectively.
#' @param df_species_epsg The EPSG number of the coordinates. This would typically be 
#' 4326 for latitude and longitude, representing WGS84.
#' @param vector_layers List of sf objects, containing islands (v_islands), parks [nature reserves]
#' (v_parks_nat_res), parks [all] (v_parks_all), unmanaged greenery (v_greenery), URA planning areas
#' (v_planning_areas).
#' If none are specified (i.e. they are NA), the function will used a preset group of vectors
#' which are loaded from the package itself through `data(vector_name)`.
#'
#' @return A data.table with appended site name and habitat type it belongs to.
#' @export
#'
#' @examples 
#' generate_habitat(df_species, c("id", "species", "type"), c("X", "Y"), 4236)
generate_habitat <- function(df_species,

							 identifier_columns = c("id", "species", "type"),
							 coord_columns = c("X", "Y"),

							 df_species_epsg = 4236,
							 
						 	 vector_layers = list(v_islands = NA, 
						 	 			    	  v_parks_nat_res = NA,
						 	 			    	  v_parks_all = NA,
						 	 			    	  v_greenery = NA,
						 	 			    	  v_planning_areas = NA)) {
 

	# Separate records with and without lat/lon

	# Those with lat/lon as sf object
	# Those without lat/lon as data.table

	sf_li <- create_species_sf_obj(df_species, coord_columns, df_species_epsg)
	v_species <- sf_li$v_species                       # used in coming up with site species matrix
	df_species_nolatlon <- sf_li$df_species_nolatlon   # check manually to assign habitat and site



	# For records with lat/lon,

	# Make spatial joins between species lat/lon and vector layers
	# Returns data.table not sf object
	df_initial_habitat <- generate_initial_habitat(v_species, vector_layers, identifier_columns)

	# Generate final site name/ habitat for each record
	df_final_habitat <- generate_final_habitat(df_initial_habitat, identifier_columns)



	# For records without lat/lon,

	# Generate final habitat for each record based on habitat column
	df_final_habitat_nll <- generate_final_habitat_nll(df_species_nolatlon, 
													   identifier_columns,
									  			       habitat_name = "habitat")


	# Combine records with and without lat/lon
	df_final_habitat_all <- rbind(df_final_habitat, df_final_habitat_nll)
	
	# Merge back to original data
	df_final_habitat_all <- merge(df_species,
								  df_final_habitat_all,
								  by = identifier_columns, 
								  all.x = T, all.y = T)


	# Return all records for manual checking
	df_final_habitat_all[order(id)]

}


# Internals ---------------------------------------------------------------


create_species_sf_obj <- function(df_species,
                                  coord_columns,
                                  df_species_epsg = 4326) {
    
    # Constants
    epsg_svy21 <- 3414
    
    
    # Filter records with lat/lon
    isXNA = is.na(df_species[[c(coord_columns[1])]])
    isYNA = is.na(df_species[[c(coord_columns[2])]])
    
    df_species_latlon <- df_species[!isXNA & !isYNA, ]
    
    # Change species coordinates to sf object
    v_species <- st_as_sf(df_species, coords=coord_columns) 
    # needs to have columns "species", "collection_date", "type", and coord columns
    
    if(is.na(st_crs(v_species))) v_species <- st_set_crs(v_species, df_species_epsg)
    
    v_species <- st_transform(v_species, epsg_svy21)
    
    
    # Filter results without lat/lon
    df_species_nolatlon <- df_species[isXNA | isYNA]
    
    
    # Returns those with lat/lon as sf object, those without as data.table
    list(v_species = v_species, df_species_nolatlon = df_species_nolatlon)
    
}


generate_initial_habitat <- function(v_species, 
                                     vector_layers,
                                     identifier_columns) {
    
    # Islands from Teo Siyang's base layers
    if (is.na(vector_layers$v_islands)) {
        v_islands <- get_data_and_assign(v_islands)
        
    } else {
        v_islands <- vector_layers$v_islands
    } 
    
    # Parks (natural reserves) from Ascher et al. (2020)
    if (is.na(vector_layers$v_parks_nat_res)) {
        v_parks_nat_res <- get_data_and_assign(v_parks_nat_res)
        
    } else {
        v_parks_nat_res <- vector_layers$v_parks_nat_res
    }
    
    # Parks (all) using SCDP parks layer, from Data.gov.sg
    if (is.na(vector_layers$v_parks_all)) {
        v_parks_all <- get_data_and_assign(v_parks_all)
        
    } else {
        v_parks_all <- vector_layers$v_parks_all
    }
    
    # Greenery in Singapore (contiguous unmanaged tree cover >=1 ha based on Gaw et al. [2019])
    if (is.na(vector_layers$v_greenery)) {
        v_greenery <- get_data_and_assign(v_greenery)
        
    } else {
        v_greenery <- vector_layers$v_greenery
    }
    
    # URA planning areas (2014) from Data.gov.sg
    if(is.na(vector_layers$v_planning_areas)) {
        v_planning_areas <- get_data_and_assign(v_planning_areas)
        
    } else {
        v_planning_areas <- vector_layers$v_planning_areas
    }
    
    
    # Get data.table from each spatial join table									 
    df_islands <- get_data_from_sp_sf(st_join(v_species, v_islands))               # islands
    df_parks_nat_res <- get_data_from_sp_sf(st_join(v_species, v_parks_nat_res))   # parks, nat res
    df_parks_all <- get_data_from_sp_sf(st_join(v_species, v_parks_all))           # parks, others
    df_greenery <- get_data_from_sp_sf(st_join(v_species, v_greenery))             # greenery
    df_planning_areas <- get_data_from_sp_sf(st_join(v_species, v_planning_areas)) # planning areas
    
    
    # Create one dataset from all the spatial join datasets by merging
    df_habitat <- merge(df_islands,
                        df_parks_nat_res,
                        by = identifier_columns, 
                        all.x = T, all.y = T,
                        suffixes = c("_island", "_parks_nr"))
    
    
    df_habitat <- merge(df_habitat, 
                        df_parks_all,
                        by = identifier_columns, 
                        all.x = T, all.y = T, 
                        suffixes = c("", "_parks_all"))
    
    names(df_habitat)[which(names(df_habitat)=="site_name")] <- "site_name_parks_all"
    
    
    df_habitat <- merge(df_habitat,
                        df_greenery,
                        by = identifier_columns, 
                        all.x = T, all.y = T, 
                        suffixes=c("", "_greenery"))
    
    names(df_habitat)[which(names(df_habitat)=="site_name")] <- "site_name_greenery"
    
    
    df_habitat <- merge(df_habitat,
                        df_planning_areas,
                        by = identifier_columns,
                        all.x = T, all.y = T, 
                        suffixes = c("", "_pa"))
    
    names(df_habitat)[which(names(df_habitat)=="site_name")] <- "site_name_pa"
    
    
    data.table(df_habitat)
    
}


generate_final_habitat <- function(df_habitat, 
                                   identifier_columns) {
    
    # Create the final habitat variable for each record
    # base on hierachy of island > parks (nat. res.) > 
    # parks (others) > greenery > planning area > none
    
    # For habitat,
    df_habitat$habitat_final <- 
        "NONE"
    
    df_habitat[!is.na(site_name_pa),]$habitat_final <- "PLANNING AREA"
    
    df_habitat[!is.na(site_name_greenery)]$habitat_final <-  # outside of parks/ nat. res.
        "GREENERY"
    
    df_habitat[!is.na(site_name_parks_all)]$habitat_final <- 
        paste0("PARKS (ALL) -- ", df_habitat[!is.na(site_name_parks_all)]$habitat)
    
    df_habitat[!is.na(site_name_parks_nr)]$habitat_final =
        "PARKS (NATURE RESERVE)"
    
    df_habitat[!is.na(site_name_island)]$habitat_final <- 
        "ISLAND"
    
    
    # For site name,
    df_habitat$site_name_final <- "NONE"
    
    df_habitat[!is.na(site_name_pa)]$site_name_final <- 
        df_habitat[!is.na(site_name_pa)]$site_name_pa 
    
    df_habitat[!is.na(site_name_greenery)]$site_name_final <- 
        df_habitat[!is.na(site_name_greenery)]$site_name_greenery  
    
    df_habitat[!is.na(site_name_parks_all)]$site_name_final <- 
        df_habitat[!is.na(site_name_parks_all)]$site_name_parks_all 
    
    df_habitat[!is.na(site_name_parks_nr)]$site_name_final <- 
        df_habitat[!is.na(site_name_parks_nr)]$site_name_parks_nr
    
    df_habitat[!is.na(site_name_island)]$site_name_final <- 
        df_habitat[!is.na(site_name_island)]$site_name_island
    
    
    
    # Create the broader habitat types for the IUCN assessment
    df_habitat <- match_habitat_to_broad_iucn_habitat(df_habitat, "habitat_final")
    
    
    # Create note column
    df_habitat$note <- "HABITAT ASSIGNMENT: SPATIAL JOIN"
    
    # Remove irrelevant columns and return
    relevant_cols <- c(identifier_columns, 
                       "site_name_final", 
                       "habitat_final", 
                       "habitat_IUCN", 
                       "note")
    df_habitat[, ..relevant_cols]
    
}


generate_final_habitat_nll <- function(df_species_nolatlon, 
                                       identifier_columns,
                                       habitat_name = "habitat") {

    
    # Create dummy dataset
    cols <- c(identifier_columns, "site_name_final", "habitat_final", "habitat_IUCN", "note")
    df_dummy <- initialize_empty_data_table(cols)
    
    # If habitat column is not NA, 
    if (!is.na(habitat_name)) {
        
        # If habitat column defined is present,
        if (habitat_name %in% names(df_species_nolatlon)) {
            
            # Remove records with no habitat
            df <- df_species_no_latlon[!( get(habitat_name) == "" | is.na(get(habitat_name)) )]
            rm(df_species_no_latlon)
            
            # Assign habitat column to habitat_IUCN column
            df[, habitat_final := get(habitat_name)]
            
            # Create dummy variables for manual checking
            df[, site_name_final := ""]
            df[, note := "HABITAT ASSIGNMENT: MANUAL"]
            
            return(df)
            
        } else {
            
            return(df_dummy)
            
        }		
        
    } else {
        
        return(df_dummy)
        
    }
    
}