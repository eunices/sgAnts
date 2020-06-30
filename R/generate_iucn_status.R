
#' Generate the IUCN status for each species
#' 
#' Generates the IUCN status for each species based on the data.table of species-habitat matrix 
#' from generate_habitat_sp_matrix function and the data.table of variables associated with 
#' boolean checks from generate_boolean_check_vars function.
#'
#' @param df_bool data.table output from generate_boolean_check_vars function. It is a data.table
#' of variables that will be used in boolean checks within this function.
#' @param df_habitat_sp_mat data.table output from generate_habitat_sp_matrix function. It is a 
#' data.table that contains the 
#' @param site_cut_off The cut-off (maximum) threshold number of sites. 
#'
#' @return A data.table with species and their corresponding boolean checks and assigned 
#' IUCN status.
#' @export
#'
#' @examples 
#' generate_iucn_status(df_bool, df_habitat_sp_mat, 2)
generate_iucn_status <- function(df_bool,
								 df_habitat_sp_mat,
								 site_cut_off = 2) {

	# Rule based assignment following flow chart

	# Combining these datasets
	df_iucn <- merge(df_bool,
				     df_habitat_sp_mat,
					 by = "species", 
					 all.x = T, all.y = T)
	# Note that specimens with records only earlier than the cut-off date will have 0 site
	# occurrences in the df_habitat_sp_mat



	# Get variables with site names
	cols_site <- names(df_iucn)[grep("n_sites", names(df_iucn))]

	# Replace NA by 0
	for (i in 1:length(cols_site)) {
		df_iucn[is.na(get(cols_site[i])), cols_site[i]] <- 0
	}

	# Tabulate total number of sites
	df_iucn$n_sites_total <- rowSums(df_iucn[, ..cols_site])     



	# Boolean checks

	# Date check
	isRecordedSinceMurphy <- df_iucn$coll_since_cut_off == "y"

	# Singleton double check
	isSingletonOrDoubletonReproductive <- 
		df_iucn$n_specimens_repro <= 2 & df_iucn$n_specimens_non_repro <= 0

	# Site check
	isRecordedInTwoOrLessSites <- df_iucn$n_sites_total <= site_cut_off

	# AOO checks
	isAOOinPrimaryMatSec <- df_iucn$n_sites.primary_mature_secondary >= 1
	isAOOinYoungSec <- df_iucn$n_sites.young_secondary >= 1
	isAOOinUrban <- df_iucn$n_sites.urban_semi_urban >= 1

	isAreaOfOccupancyInYoungSecAndPriMatSecOnly <- 
		isAOOinPrimaryMatSec & isAOOinYoungSec & !isAOOinUrban

	isAreaOfOccupancyInYoungSecOnly <- 
		!isAOOinPrimaryMatSec & isAOOinYoungSec & !isAOOinUrban

	isAreaOfOccupancyInPriMatSecOnly <- 
		isAOOinPrimaryMatSec & !isAOOinYoungSec & !isAOOinUrban


	# Creating the final dataset template based on flowchart
	df_final <- data.table(species=df_iucn$species, 
						   isRecordedSinceMurphy,
						   isSingletonOrDoubletonReproductive,
						   isRecordedInTwoOrLessSites,
						   isAOOinUrban,
						   isAreaOfOccupancyInYoungSecAndPriMatSecOnly,
						   isAreaOfOccupancyInYoungSecOnly,
						   isAreaOfOccupancyInPriMatSecOnly)


	# Assessing IUCN statuses using boolean checks
	isDataDeficient1 <- !isRecordedSinceMurphy & isSingletonOrDoubletonReproductive
	isToBeManuallyDefined <- !isRecordedSinceMurphy & !isSingletonOrDoubletonReproductive

	isCriticallyEndangered <- isRecordedSinceMurphy & 
		isRecordedInTwoOrLessSites & 
		isAreaOfOccupancyInPriMatSecOnly

	isDataDeficient2 <- isRecordedSinceMurphy & 
		isRecordedInTwoOrLessSites & 
		!isAreaOfOccupancyInPriMatSecOnly

	isLeastConcern <- isRecordedSinceMurphy & 
		!isRecordedInTwoOrLessSites & 
		isAOOinUrban

	isNearThreatened <- isRecordedSinceMurphy & 
		!isRecordedInTwoOrLessSites & 
		isAreaOfOccupancyInYoungSecAndPriMatSecOnly

	isVulnerable <- isRecordedSinceMurphy & 
		!isRecordedInTwoOrLessSites &
		isAreaOfOccupancyInYoungSecOnly

	isEndangered <- isRecordedSinceMurphy & 
		!isRecordedInTwoOrLessSites & 
		isAreaOfOccupancyInPriMatSecOnly


	# Appending statuses to dataset
	df_final$category_iucn <- "No status"
	df_final[isDataDeficient1]$category_iucn <- "Data Deficient"
	df_final[isToBeManuallyDefined]$category_iucn <- "! MANUAL CHECK (DD/NE)"
	df_final[isCriticallyEndangered]$category_iucn <- "Critically Endangered"
	df_final[isDataDeficient2]$category_iucn <- "Data Deficient"
	df_final[isLeastConcern]$category_iucn <- "Least Concern"
	df_final[isNearThreatened]$category_iucn <- "Near Threatened"
	df_final[isVulnerable]$category_iucn <- "Vulnerable"
	df_final[isEndangered]$category_iucn <- "Endangered"

	# Summarise results and return
	df_final

}
