
get_data_from_sp_sf <- function (sf_object, identifier_columns) {

	data <- get_data_from_sf(sf_object)
	
	cols <- c(identifier_columns, "NAME")
	if ("habitat" %in% names(data)) {
		cols <- c(cols, "habitat")
	}
	
	data <- subset(data, select = cols)
	names(data)[which(names(data)=="NAME")] <- "site_name"

	data

}

get_data_from_sf <- function(sf_object) {
	sf::st_geometry(sf_object) = NULL
	data.table::data.table(sf_object)
}


get_data_and_assign <- function(...) {

	e <- new.env()
	name <- data(..., envir = e)[1]

	e[[name]]

}

initialize_empty_data_table <- function(column_names) {
	data.table::data.table(NA)[, `:=` (eval(column_names), NA)][!is.na(V1)][, V1:=NULL]
}