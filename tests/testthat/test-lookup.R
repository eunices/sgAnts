test_that("match_habitat_to_broad_iucn_habitat function works", {

  mock_data <- data.table(data.frame(habitat=c("PLANNING AREA", 
                                               "URBAN/SEMI-URBAN",
                                               "GREENERY", 
                                               "ISLAND", 
                                               "YOUNG SECONDARY FOREST",
                                               "MANGROVE", 
                                               "NATURE RESERVE")))
  matched_data <- match_habitat_to_broad_iucn_habitat(mock_data, "habitat")
  
  categories <- c("Urban/semi-urban", 
                  "Young secondary",
                  "Primary/ mature secondary")

  expect_true(all(matched_data$habitat_IUCN %in% categories))

})

