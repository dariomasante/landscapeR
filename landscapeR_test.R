library(raster)
m = matrix(0, 33, 33)
r = raster(m, xmn=0, xmx=10, ymn=0, ymx=10)

## OK
plot(makeClass(r, 5, 15))
plot(makeClass(r, 1, 1))
plot(makeClass(r, 2, 15, pts=c(1,60)))
plot(makeClass(r, 2, c(15,150), pts=c(1,500)))
plot(makeClass(r, 2, c(15,5000), pts=c(1,500))) ## throws warnings
plot(makeClass(r, 5, 15, val=5))
plot(makeClass(r, 5, 15, bgr=c(0,1)))
plot(makeClass(r, 5, 15, bgr=c(0,1), val=5))
rr=makeClass(r, 5, 100); rr = makeClass(rr, 5, 50, val=5); plot(rr)
plot(makeClass(rr, 5, 50, bgr=c(0,1), val=3)); rm(rr)

## MUST FAIL
plot(makeClass(r, 0, 5))
plot(makeClass(r, NA, 5))
plot(makeClass(r, 2, 15, pts=c(1)))
plot(makeClass(r, 2, c(15,150,300), pts=c(1,500)))
plot(makeClass(r, 5, 15, bgr=5))
plot(makeClass(r, 5, 15, bgr=5, val=5))
plot(makeClass(r, 2, 15, pts=c(1,5000)))
plot(makeClass(r, c(5,4)))
plot(makeClass(r, 2, c(15,NA)))
plot(makeClass(r, 2, 15, pts=c(1,NA)))
plot(makeClass(r, 5, 0))
plot(makeClass(r, 5, -10))
plot(makeClass(r, 5, 15, val=0))
plot(makeClass(r, 5, 15, val=c(5,4)))

## FIX

 ## Return sensible error

## Create a class of three patches of given size at three corners of the spatial context
size = c(10, 50, 200)
pts = c(1, 33, 1089)
rr = makeClass(r, 3, size, pts)
plot(rr)


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
