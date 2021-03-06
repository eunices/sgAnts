# Load data

data("sg_ants_test")

df_species <- sg_ants_test

identifier_columns <- c("id", "species", "type")
coord_columns <- c("X", "Y")

collection_date_column <- "collection_date"
date_cut_off <- as.Date("1960-01-01")


# Main script

df_habitat <- 
    generate_habitat(df_species, identifier_columns, coord_columns)

df_habitat_sp_mat <-
    generate_habitat_sp_matrix(df_habitat, collection_date_column, date_cut_off)

df_bool <-
    generate_boolean_check_vars(df_species, date_cut_off)

df_iucn <-
    generate_iucn_status(df_bool, df_habitat_sp_mat)

# A summary
df_iucn[, list(n=.N, percentage=.N/dim(df_iucn)[1] * 100), by="category_iucn"]


# Ancillary functions

p = classify_parks()
p
