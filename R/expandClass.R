#' Expand an existing class of patches.
#
#' @inheritParams makePatch
#' @inheritParams makeClass
#' @param class (or patch),
#' @param size integer. Size of expansion, as number of raster cells.
#' @param bgr integer. The background available where expansion is allowed (i.e. shrinking classes).
#' @return A RasterLayer object. If \code{rast=FALSE} returns a list of vectors, each containing the \code{context} cells assigned to each patch.
#' @examples
#' library(raster)
#'
#' m = matrix(0, 33, 33)
#' r = raster(m, xmn=0, xmx=10, ymn=0, ymx=10)
#' r = makeClass(r, 5, 10)
#' plot(r)
#'
#' rr = expandClass(r, 1, 100)
#' plot(rr)
#'
#' ## This function can be used to mimic shapes, by providing a skeleton:
#' m[,17] = 1
#' r = raster(m, xmn=0, xmx=10, ymn=0, ymx=10)
#' plot(r)
#'
#' rr = expandClass(r, 1, 100)
#' plot(rr)
#' @export
expandClass <- function(context, class, size, bgr=0, pts = NULL) {
  bd <- raster::boundaries(context, type='outer', classes=TRUE, directions=8)
  bd <- t(raster::as.matrix(bd))
  if(!is.matrix(context)) {m <- t(raster::as.matrix(context))} else {m <- context}
  if(is.null(pts)){edg <- which(bd==1 & m==class)} else {edg <- pts}
  bgrCells <- which(m == bgr)
  if(length(bgrCells) == 0){stop('No cells available, landscape full')}
  if(size > (length(bgrCells))){stop('Expansion size bigger than available landscape')}
  pts <- ifelse(length(edg) == 1, edg, sample(edg, 1) )
  dim1 <- dim(m)[1]
  dim2 <- dim(m)[2]
  cg <- 1
  while(cg < size){
    ad <- .contigCells(pts, dim1, dim2)
    ## The following stands for {ad <- bgrCells[which(bgrCells %in% ad)]}
    ad <- ad[m[ad] == bgr]
    if(length(ad) == 0) {
      edg <- edg[edg!=pts]
      if(length(edg) <= 1) {
        if(cg == 1){
          warning('Expanding classes do not touch shrinking classes. Input raster returned')
          break
        } else {
          warning('Maximum patch size reached: ', cg)
          break
        }
      }
      pts <- sample(edg, 1)
      next
    }
    m[ad] <- class
    cg <- cg + length(ad)
    edg <- c(edg[edg != pts], ad)
    pts <- ifelse(length(edg) == 1, edg, sample(edg, 1) )
  }
  context[] <- t(m)
  return(context)
}
