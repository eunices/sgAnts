
#' Generate variables needed for boolean checks for each species
#'
#' @param df_species A data.table containing individual species records. 
#' Should minimally have specimen identifier, species identity, verbatim locality and/or 
#' latitude and longitude, collection date and specimen type (worker/ reproductive).
#' @param date_cut_off The date cut-off for the bifurcation of the flow chart. 
#' See Wang et al. (2020) Figure 1 for details. 
#'
#' @return A data.table of variables used later in the boolean checks in the generate_iucn_status 
#' function. 
#' @export
#'
#' @examples 
#' data("sg_ants_test")
#' generate_boolean_check_vars(sg_ants_test, as.Date("1960-01-01"))
generate_boolean_check_vars <- function(df_species,
									    date_cut_off = as.Date("1960-01-01")) {

	# Create matrix for specimen last record date, N specimens, N reproductive specimens
	# used in boolean checks for red list (first half)
	# based on cut off date, singleton/doubleton of reproductive caste

	df_bool <- df_species[, list(coll_date_last = max(collection_date, na.rm=T), 
							  	 n_specimens_non_repro = .N,
							  	 n_specimens_repro = sum(type=="reproductive")), by="species"]

	df_bool$coll_since_cut_off <- ifelse(df_bool$coll_date_last < date_cut_off, "n", "y")

	df_bool

}