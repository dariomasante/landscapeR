# landscapeR
A landscape simulator for R

To install:
- download the source file [landscapeR_0.1.0.tar.gz](https://github.com/dariomasante/landscapeR/blob/master/landscapeR_0.1.0.tar.gz) to the R working directory (or any other directory)
- start an R session
- run the following commands in the console:
``` r
## Install the required packages 
install.packages("raster", repos="http://cran.uk.r-project.org/", dependencies=T, clean=T)
install.packages("fastmatch", repos="http://cran.uk.r-project.org/", dependencies=T, clean=T)

## Install landscapeR (full path to the file, if not in the R working directory)
install.packages("~/landscapeR_0.1.0.tar.gz", repos = NULL, type="source")

## Load packages
require(raster)
require(fastmatch)
require(landscapeR)
```
