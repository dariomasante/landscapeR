# landscapeR
A landscape simulator for R. 

This has been updated by Lora Murphy to be compatible with the terra package, and to add additional features. Original package logic still wholly credited to Dario Masante.

This package is aimed at simulating categorical landscapes on actual geographical realms, starting from either empty landscapes or landscapes provided by the user (e.g. land use maps). The purpose is to provide a tool to tweak or create the landscape while retaining a high degree of control on its features, without the hassle of specifying each location attribute. In this it differs from other tools which generate null or neutral landscape in a theorethical space. All basic GIS operations are handled by the [raster](https://cran.r-project.org/package=raster) package.

URL: https://cran.r-project.org/package=landscapeR  
Reference manual: [landscapeR.pdf](https://cran.r-project.org/web/packages/landscapeR/landscapeR.pdf)

Citation: Thomas, A., Masante, D., Jackson, B., Cosby, B., Emmett, B., Jones, L. (2020). Fragmentation and thresholds in hydrological flow-based ecosystem services. Ecological Applications. https://doi.org/10.1002/eap.2046

This version of this package is NOT available on CRAN. To install, use devtools:

```r
install.packages("devtools")
devtools::install_github("Forest-Futures-Lab/landscapeR")
```

Without devtools, download the source code. Open an R session and navigate to the directory containing the source code. Use the following command in R:
```r
install.packages("landscapeR", repos=NULL, type="source")
```

If you need to remove an existing install of the package:

```r
remove.packages("landscapeR")
```

## Load package
library(landscapeR)
```

Here it follows a set of examples, using landscapeR functions to generate various landscape configurations. 
Similar examples are showed in the [vignette](http://htmlpreview.github.com/?https://github.com/dariomasante/landscapeR/blob/master/landscapeR.html).
Let's start loading the required packages and making an empty landscape (by transforming a matrix into a geographical obkect):
```{r, message=FALSE, warning=FALSE}
library(landscapeR)

## Create an empty landscape
library(terra)
m = matrix(0, 33, 33)
r = rast(m)
ext(r) = c(0, 10, 0, 10)
```

### `makePatch`
This is the basic function to create a single patch. For instance:
```{r, eval=FALSE}
rr = makePatch(r, size=500, rast=TRUE)
plot(rr)
```

Some more features can be specified about the patch. For example, the following will create a patch with value 3, starting from the centre cell of the raster:
```{r}
patchSize = 500
newVal = 3
centre = 545
rr = makePatch(r, patchSize, centre, val=newVal, rast=TRUE)
plot(rr)
```

Forbidden cells can be specified by value, so the patch will occupy only the allowed background. The following will generate a new patch with value 5 and size 100 inside the existing patch:
```{r, warning=FALSE}
rr = makePatch(rr, 100, bgr=newVal, rast=TRUE, val=5)
plot(rr)
```

### `makeClass`
`makeClass` generates a group of patches, as specified by its arguments. Example:
```{r, warning=FALSE}
num = 5
size = 15
rr = makeClass(r, num, size)
plot(rr)
```

Patches are allowed to be contiguous, so they may appear as a single patch in those instances:
```{r, warning=FALSE}
num = 75
size = 10
rr = makeClass(r, num, size)
plot(rr)
```

Each patch size and seed starting position can be specified as well:
```{r}
num = 5
size = c(1,5,10,20,50)
pts = c(1, 33, 1089, 1057, 545)
rr = makeClass(r, num, size, pts)
plot(rr)
```

### `expandClass`
Expand (and shrinks) classes starting from an existing landscape. Building on the previous:
```{r}
rr = expandClass(rr, 1, 250)
plot(rr)
```

This function can be used to mimic shapes, by providing a skeleton:
```{r}
m[,17] = 1
r = rast(m)
ext(r) = c(0, 10, 0, 10)
par(mfrow=c(1,2))
plot(r)
rr = expandClass(r, 1, 200)
plot(rr)
```

### `makeLine`
Create a linear patch, setting direction and convolution. The higher the convolution degree, the weaker the
linear shape (and direction).
```{r}
par(mfrow=c(1,2))
rr = makeLine(r, size=50, direction=90, rast=TRUE, spt=545, convol=0.25)
plot(rr)

plot(makeLine(r, size=50, direction=90, rast=TRUE, spt=545, convol=0.6))
```

