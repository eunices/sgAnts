
https://r-pkgs.org/whole-game.html

## For initializing purposes

create_package()


## For updating purposes

### Package level

load_all()
check()
document()

#### Specific stuff
use_package()
use_data()

### Finalising
build() # create tar.gz

### Function level

use_r("functionName")

## .RbuildIgnore
`^.*\.Rproj$         ` # Designates the directory as an RStudio Project
`^\.Rproj\.user$     ` # Used by RStudio for temporary files
`^README\.Rmd$       ` # An Rmd file used to generate README.md
`^LICENSE\.md$       ` # Full text of the license
`^cran-comments\.md$ ` # Comments for CRAN submission
`^\.travis\.yml$     ` # Used by Travis-CI for continuous integration testing
`^data-raw$          ` # Code used to create data included in the package
`^pkgdown$           ` # Resources used for the package website
`^_pkgdown\.yml$     ` # Configuration info for the package website
`^\.github$          ` # Contributing guidelines, CoC, issue templates, etc.

## Data
`data/` for data to be loaded (lazy loading) (if internal, argument internal=T)
`data-raw/` for raw data for to generate data/
`inst/extdata` for example data, can shown in vignette
can store data in `test/` for test data

