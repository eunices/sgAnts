
#' Classify parks based on threshold
#' 
#' \code{classify_parks} returns a sf object of parks with habitat column.
#' 
#' This function takes the Singapore park gpkg and reclassifies the geospatial files
#' based on rules defined by minimum park size \code{min_park_size}, minimum area for unmanaged
#' trees \code{min_unmanaged_tree_area}, minimum percentage of vegetation 
#' \code{min_vegetation_percentage}.
#' 
#' @param min_park_size Minimum park size to be filtered for, in m^2.
#' @param min_unmanaged_tree_area Minimum unmanaged trees area to be classified as secondary forest
#' habitat, in m^2. 
#' @param min_vegetation_percentage Minimum percentage of vegetation for parks to be classified as
#' secondary forest habitat, in m^2.
#' 
#' @return An sf object that contains the Singapore park geospatial layer.
#' 
#' @export
#' 
#' @examples 
#' classify_parks(10000, 10000, 80, NA)
classify_parks <- function(min_park_size = 10000, 
						   min_unmanaged_tree_area = 10000, 
						   min_vegetation_percentage = 80,
						   v_parks_all = NA) {

	# Read park layer
	if (is.na(v_parks_all)) {

		p <- get_data_and_assign(v_parks_all)

	} else {

		p <- v_parks_all
		rm(v_parks_all)

	}


	# Parameters
	threshold_park_size <- min_park_size
	threshold_unmanaged_trees <- min_unmanaged_tree_area / 5  # 5m^2/pixel
	threshold_vegetation <- min_vegetation_percentage


	# Boolean checks
	isLarge <- p$AREA_SQ_M > threshold_park_size
	
	isMangrove <- p$mangrove > 1

	isForestCover <- p$veg_canopy_unmanaged >= threshold_unmanaged_trees &
		p$prop_veg > threshold_vegetation


	# Assignment
	p[!isLarge,]$habitat <- "SMALL GREEN SPACE"                                   # Small parks
	p[isLarge & isMangrove,]$habitat <- "MANGROVE"                                # Mangrove
	p[isLarge & !isMangrove & !isForestCover,]$habitat <- "URBAN/SEMI-URBAN"      # Urban/semi-urban
	p[isLarge & !isMangrove & isForestCover,]$habitat <- "YOUNG SECONDARY FOREST" # Young secondary


	# Print reuslts
	print(table(isLarge))
	print(table(p$habitat))

	p
}
