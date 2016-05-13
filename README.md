# landscapeR
A landscape simulator for R. 
This package is aimed at simulating categorical landscapes on actual geographical realms, starting from either empty landscapes or landscapes provided by the user (e.g. land use maps). The purpose is to provide a tool to tweak or create the landscape while retaining a high degree of control on its features, without the hassle of specifying each location attribute. In this it differs from other tools which generate null or neutral landscape in a theorethical space. All basic GIS operations are handled by the [raster](https://cran.r-project.org/web/packages/raster/index.html) package.

To install:
- download the source file [landscapeR_0.1.0.tar.gz](https://github.com/dariomasante/landscapeR/blob/master/landscapeR_0.1.0.tar.gz?raw=true) to the R working directory (or any other directory)
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
