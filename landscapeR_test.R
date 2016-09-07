library(raster)
library(landscapeR)
m = matrix(1, 33, 33)
r = raster(m, xmn=0, xmx=10, ymn=0, ymx=10)
r = makePatch(r, size=600, spt=545, rast=TRUE, bgr=1, val=0)
r[r == 1] = NA; plot(r)

## OK
par(mfrow=c(2,2))
plot(makeClass(r, 5, 15))
plot(makeClass(r, 1, 1))
plot(makeClass(r, 2, 15, pts=c(644,446)))
plot(makeClass(r, 2, 15, pts=c(1,545))) ## throws warnings if 1 has NA value

plot(makeClass(r, 2, c(15,150), pts=c(644,446)))
plot(makeClass(r, 2, c(15,5000), pts=c(644,446))) ## throws warnings
plot(makeClass(r, 5, 15, val=5))
plot(makeClass(r, 5, 15, bgr=c(0,1))) ## throws warnings

plot(makeClass(r, 5, 15, bgr=c(0,NA)))
plot(makeClass(r, 5, 15, bgr=c(0,1), val=5))
rr=makeClass(r, 5, 50); rr = makeClass(rr, 5, 50, val=5); plot(rr)
plot(makeClass(rr, 5, 50, bgr=c(0,1), val=3)); rm(rr)

plot(makeClass(r, 5, 15, val=0)) ## throws warnings
makeClass(r, 5, 15, rast=FALSE)
makeClass(r, 3, c(10,12,5), rast=FALSE)


## MUST FAIL
makeClass(r, 3, c(0,12,5), rast=FALSE)
makeClass(r, 2, c(15,150), pts=c(1,2))
makeClass(r, 1, 15, pts=1) # Will not throw error if cell 1 has non NA value
makeClass(r, 0, 5)
makeClass(r, NA, 5)
makeClass(r, 2, 15, pts=446)
makeClass(r, 2, c(15,150,300), pts=c(1,500))
makeClass(r, 5, 15, bgr=5)
makeClass(r, 5, 15, bgr=5, val=5)
makeClass(r, 2, 15, pts=c(1,5000))
makeClass(r, c(5,4))
makeClass(r, 2, c(15,NA))
makeClass(r, 2, 15, pts=c(1,NA))
makeClass(r, 5, 0)
makeClass(r, 5, -10)
makeClass(r, 5, 15, val=c(5,4))

## FIX

 ## Return sensible error

## Create a class of three patches of given size at three corners of the spatial context
size = c(10, 50, 200)
pts = c(1, 33, 1089)
rr = makeClass(r, 3, size, pts)
plot(rr)

################# MAKE PATCH
## OK
par(mfrow=c(2,2))
plot(makePatch(r, 50, rast=TRUE))
plot(makePatch(r, 1, rast=TRUE))
plot(makePatch(r, 2, spt=446, rast=TRUE))
plot(makePatch(r, 50, spt=446, edge=TRUE, rast=TRUE))

makePatch(r, 15, spt=446)
makePatch(r, 1, spt=446)
makePatch(r, 1, spt=446, edge=TRUE)
makePatch(r, 15, spt=446, edge=TRUE)
makePatch(r, 15, val=1, edge=TRUE)
makePatch(r, 15, val=0, edge=TRUE)
plot(makePatch(r, 50, val=5, rast=TRUE))

## MUST FAIL
makePatch(r, c(15,150)) #
makePatch(r, 20, spt=c(644,446))
makePatch(r, 20, spt=1)
makePatch(r, NA, spt=1, rast=TRUE)
makePatch(r, 20, spt=NA, rast=TRUE)
makePatch(r, -1, spt=1, rast=TRUE)
makePatch(r, 20, spt=-1, rast=TRUE)
makePatch(r, 0, spt=1, rast=TRUE)
makePatch(r, 20, spt=0, rast=TRUE)
makePatch(r, 100000000, spt=1, rast=TRUE)
makePatch(r, 20, spt=10000000, rast=TRUE)
makePatch(r, 20, val=c(2,4), rast=TRUE)
makePatch(r, 20, bgr=c(0,1), rast=TRUE)

## FIX
#plot(makePatch(r, 50, val=15, bgr=c(0,1), rast=TRUE)) ## throws warnings
#plot(makePatch(r, 50, val=15, bgr=c(1,0), rast=TRUE))
#plot(makePatch(r, 50, val=15, bgr=c(NA,1), rast=TRUE))

################# MAKE LINE
## OK
par(mfrow=c(2,2))
plot(makeLine(r, 30, rast=TRUE))
plot(makeLine(r, 30, spt=445, rast=TRUE))
plot(makeLine(r, 30, rast=TRUE, val=3))
plot(makeLine(r, 30, rast=TRUE, direction=90))

plot(makeLine(r, 30, rast=TRUE, convol=0.05))
plot(makeLine(r, 30, rast=TRUE, spt=664))
plot(makeLine(r, 30, rast=TRUE, edge=TRUE))
plot(makeLine(r, 1, rast=TRUE))
makeLine(r, 30, edge=TRUE)
makeLine(r, 30)
makeLine(r, 30, spt=445)

## FAILS
plot(makeLine(r, NA, rast=TRUE)) # Add error message

## FIX
plot(makeLine(r, 0, rast=TRUE))
plot(makeLine(r, 30, rast=TRUE, val=3, bgr=c(NA,0)))
plot(makeLine(r, 30, rast=TRUE, val=3, bgr=1)) ## Throws warning

#################
## Create linear features randomly
r = matrix(0,50,50); r = raster::raster(r, xmn=0, xmx=10, ymn=0, ymx=10)
s = 1275#sample(length(r),1)
r[s] = 1
size = 100
cg = s
while(length(cg) < size){
  ad = raster::adjacent(r,s,pairs=FALSE,directions=4)
  d = ad[!ad %in% cg]
  if(length(d) == 1) {
    s = d
  }
  else if(length(d) == 0) {
    s = sample(ad,1)
  }
  else {
    s = sample(d,1)
  }
  cg = c(cg, d) ##cg = c(cg, s) ##  to have a 1 cell line (but fix as is less than size)
}
r[cg] = 1
raster::plot(r); length(which(raster::getValues(r)==1))

################ TEST .direction parameters:
#% library(ggplot2); library(reshape2)
#% sq = seq(0.01,0.99,0.02)
#% nm = 1:8
#% tb = do.call(rbind.data.frame, lapply(sq, function(x){
#%   row = table(.direction(90, x, 100000, directions=8))/1000
#%   if(length(row) < 8){ row = row[match(nm, names(row))]; row[is.na(row)] = 0 }
#%   return(row) }))
#% names(tb) = nm
#% d = tb; d$xax = sq; d <- melt(d, id.vars="xax")
#% ggplot(d, aes(xax,value, col=variable)) + geom_line(); tb
