# Singapore Ants (SgAnts) R Package

![R-CMD-check](https://github.com/eunices/sgAnts/workflows/R-CMD-check/badge.svg)
[![codecov](https://codecov.io/gh/eunices/sgAnts/branch/master/graph/badge.svg)](https://codecov.io/gh/eunices/sgAnts)

## For development

### Updating package after edits

```
devtools::document(roclets = c('rd', 'collate', 'namespace'))
```

### Before pushing to branch...

```
testthat::test()
rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), 
                        error_on = "warning",
                        check_dir = "check")
```

- Pull request
- Merge to master after paassing tests

## For usage

### Installing 
```
devtools::install_github("eunices/sgAnts") 
```

### Functions

See `main-test-data.R`


## Resources

- https://ropenscilabs.github.io/actions_sandbox/testing-with-renev.html
- https://github.com/r-lib/actions/tree/master/examples#test-coverage-workflow