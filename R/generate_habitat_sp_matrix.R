
#' Generate habitat versus species matrix
#' 
#' Generates the habitat versus species matrix, by counting the number of unique sites,
#' based on the record-habitat matrix with the site name and corresponding habitat type columns.
#'
#' @param df_habitat The data.table with records of ant species, site name and its corresponding
#' habitat type.
#' @param collection_date_column The name of the collection date column.
#' @param date_cut_off The cut-off (maximum) threshold date for the collection date (inclusive).
#'
#' @return A data.table that contains species (rows) versus habitat (columns) with values 
#' representing number of unique sites it is found in for that habitat type.
#' @export
#'
#' @examples 
#' generate_habitat_matrix(df_habitat, "collection_date", as.Date("1960-01-01"))
generate_habitat_sp_matrix <- function(df_habitat,
									   collection_date_column = "collection_date", 
									   date_cut_off = as.Date("1960-01-01")) {
	
	# Generate habitat matrix
	# by counting number of unique sites of  habitat for each species


	# Subset data from cut-off date
	df_habitat <- df_habitat[get(collection_date_column) >= date_cut_off]


	# Subset relevant columns
	cols <- c("species", "site_name_final", "habitat_IUCN")
	df_habitat_sp_mat <- df_habitat[, ..cols]
	

	# Only take unique sites
	df_habitat_sp_mat <- unique(df_habitat_sp_mat)


	# Subset only those falling within these categories
	categories_habitat_IUCN <- c("Urban/semi-urban", 
								 "Young secondary", 
								 "Primary/ mature secondary")

	df_habitat_sp_mat <- df_habitat_sp_mat[habitat_IUCN %in% categories_habitat_IUCN]

	df_habitat_sp_mat$habitat_IUCN <- factor(df_habitat_sp_mat$habitat_IUCN, 
										  levels = categories_habitat_IUCN)


	# Reshape data and count number of sites by habitat_IUCN
	df_habitat_sp_mat <- dcast(df_habitat_sp_mat, 
				               species~habitat_IUCN,
					           fun.aggregate = length,
					           value.var = "species")


	# Format habitat names
	names(df_habitat_sp_mat) <- gsub("__", "_", 
					              tolower(
									  gsub("[^[:alnum:]\\-\\.\\s]", "_", names(df_habitat_sp_mat))
									  	 )
								     )

	names(df_habitat_sp_mat)[2:length(names(df_habitat_sp_mat))] <- 
		paste0("n_sites.", names(df_habitat_sp_mat)[2:length(names(df_habitat_sp_mat))])


	# Return matrix
	df_habitat_sp_mat

}