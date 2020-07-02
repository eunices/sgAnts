#' sg_ants_test
#'
#' A dataset containing simulated ant distribution data in Singapore
#'
#' @format An data.table with 313 rows and 6 columns:
#' \describe{
#'   \item{species}{species name}
#'   \item{X}{X coordinate (i.e. longitude)}
#'   \item{Y}{Y coordinate (i.e. latitude)}
#'   \item{collection_date}{collection date in YYYY-MM-DD}
#'   \item{type}{type of specimen (worker, reproductive)}
#'   ...
#' }
#' @source \url{https://github.com/eunices/sgAnts/}
"sg_ants_test"


#' v_greenery
#'
#' A geospatial vector layer for unmanaged greenery (with tree cover) patches in Singapore based on 
#' Gaw et al. (2019) https://www.mdpi.com/2306-5729/4/3/116. 
#'
#' @format An sf object with 449 rows and 3 columns:
#' \describe{
#'   \item{NAME}{Site name}
#'   \item{geom}{Points within sf object}
#'   \item{AREA_SQ_M}{Area of greenery patch, in sq km}
#'   ...
#' }
#' @source \url{https://www.mdpi.com/2306-5729/4/3/116/}
"v_greenery"



#' v_islands
#'
#' A geospatial vector layer for islands in Singapore from the basemap of Singapore
#' by Teo Siyang.
#'
#' @format An sf object with 43 rows and 3 columns:
#' \describe{
#'   \item{NAME}{Site name}
#'   \item{geom}{Points within sf object}
#'   ...
#' }
#' @source \url{https://github.com/eunices/sgAnts/}
"v_islands"



#' v_parks_all
#'
#' A geospatial vector layer for parks in Singapore from SDCP parks accessed on May 2020  from 
#' https://data.gov.sg/dataset/sdcp-park?resource_id=9584bbb8-bd5c-49fe-ac58-55734fb56538
#'
#' @format An sf object with 557 rows and 17 columns:
#' \describe{
#'   \item{NAME}{Site name}
#'   \item{geom}{Points within sf object}
#'   \item{habitat}{Assigned habitat based on rules outlined in Wang et al.}
#'   \item{AREA_SQ_M}{Area of site, in sq km.}
#'   \item{prop_veg_canopy_unmanaged}{Proportion of pixels of unmanaged vegetation with canopy
#'   of entire site. }
#'   \item{prop_veg_canopy}{Proportion of pixels of vegetation with canopy of entire site.}
#'   \item{prop_veg}{Proportion of pixels with vegetation of entire site.}
#'   \item{prop_veg_no_canopy_of_veg}{Proportion of vegetation with no canopy based on counting
#'   pixels from Gaw et al. (2019)}
#'   \item{mangrove}{Number of pixels which is mangrove based on Gaw et al. (2019)}
#'   \item{veg_canopy_unmanaged}{Number of pixels which is unmanaged greenery with canopy based on
#'   Gaw et al. (2019)}
#'   ...
#' }
#' @source 
#' \url{https://data.gov.sg/dataset/sdcp-park?resource_id=9584bbb8-bd5c-49fe-ac58-55734fb56538}
"v_parks_all"



#' v_parks_nat_res
#'
#' A geospatial vector layer for parks (nature reserves) in Singapore from the basemap of Singapore
#' by Teo Siyang.
#'
#' @format An sf object with 9 rows and 13 columns:
#' \describe{
#'   \item{NAME}{Site name}
#'   \item{geom}{Points within sf object}
#'   ...
#' }
#' @source \url{https://github.com/eunices/sgAnts/}
"v_parks_nat_res"



#' v_planning_areas
#'
#' A geospatial vector layer for planning areas in Singapore from 
#' https://data.gov.sg/dataset/master-plan-2014-planning-area-boundary-no-sea.
#'
#' @format An sf object with 52 rows and 14 columns:
#' \describe{
#'   \item{NAME}{Site name}
#'   \item{geom}{Points within sf object}
#'   \item{OBJECTID}{OBJECTID variable found in original datasets. Can be used as an identifier.}
#'   ...
#' }
#' @source \url{https://data.gov.sg/dataset/master-plan-2014-planning-area-boundary-no-sea/}
"v_planning_areas"

