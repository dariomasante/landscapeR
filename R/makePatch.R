#' Create a single patch
#'
#' @param context Raster object or matrix, an empty landscape raster or a mask indicating where the patch cannot be generated (see bgr below).
#' @param size integer. Size of the patch to be generated, as number of raster cells.
#' @param spt integer or matrix. The seed point location around which the patch is generated (a random point is given by default). It can be an integer, as index of the cell in the raster, or a two columns matrix indicating x and y coordinates (or an integar vector of length 2).
#' @param bgr integer. Value of background cells, where a patch can be generated (default is zero). Cells/classes which cannot be changed must have a different value.
#' @param edge logical. Should the vector of edge cells of the patch be returned?
#' @param rast logical. If TRUE returns a Raster object, otherwise a vector of cell numbers where the patch occurs
#' @param val integer. The value to be assigned to patch cells, when \code{rast=TRUE}
#' @return A vector of raster cell numbers, or a RasterLayer object if \code{rast=TRUE}. If \code{edge=TRUE} a
#' list of two vectors is returned: one for the inner raster cells and the second for cells at the edge of the patch.
#' @details The patch is created starting from the seed point and iteratively sampling randomly neighbouring cells at the edge of the patch.
#' There is a tolerance of +/- 3 cells from the patch size declared in \code{size} argument.
#' @examples
#' library(raster)
#' mtx = matrix(0, 33, 33)
#' r = raster(mtx, xmn=0, xmx=10, ymn=0, ymx=10)
#' patchSize = 500
#' rr = makePatch(r, patchSize, rast=TRUE)
#' plot(rr)
#'
#' ## Create a patch with value 3, starting from the centre cell
#' mtx = matrix(0, 33, 33)
#' r = raster(mtx, xmn=0, xmx=10, ymn=0, ymx=10)
#' newVal = 3
#' centre = 545
#' cells = makePatch(r, patchSize, centre)
#' r[cells] = newVal
#' plot(r)
#'
#' ## Now create a new patch with value 10 and size 100 inside the existing patch
#' rr = makePatch(r, 100, bgr=newVal, rast=TRUE, val=10)
#' plot(rr)
#' @export
makePatch <- function(context, size, spt=NULL, bgr=0, edge=FALSE, rast=FALSE, val=1) {
  if(!is.matrix(context)) {
    if(!is.null(spt)){
      if(length(spt) == 2){
        spt <- matrix(spt, ncol=2)
      }
      spt <- .toCellIndex(context, spt)
    }
    mtx <- t(raster::as.matrix(context))
  } else {
    mtx <- context
  }
  bgrCells <- which(mtx == bgr)
  if(length(bgrCells) == 0){
    stop('No background cells available, landscape full. Try checking argument "bgr".')
  }
  if(size > length(bgrCells)){
    warning('Patch size bigger than available background.')
  }
  spt <- ifelse(is.null(spt), sample(bgrCells, 1), spt)
  if(mtx[spt] != bgr){
    wp <- spt
    spt <- ifelse(length(bgrCells) > 1, sample(bgrCells, 1), bgrCells)
    warning('Seed point  ', wp, '  outside background. Re-sampled randomly inside it. New seed:  ', spt)
  }
  mtx[spt] <- val
  edg <- spt
  dim1 <- dim(mtx)[1]
  dim2 <- dim(mtx)[2]
  cg = 1
  while(cg < size){
    ad <- .contigCells(spt, dim1, dim2)
    ## The following stands for {ad <- bgrCells[which(bgrCells %in% ad)]}; {d <- fastmatch::fmatch(ad, bgrCells, nomatch = 0);ad <- bgrCells[d]}
    ad <- ad[mtx[ad] == bgr]
    if(length(ad) == 0) {
      edg <- edg[edg != spt]
      if(length(edg) <= 1) {
        warning('Patch size reached from seed point ', spt, ' was ', cg, ' . No further background cells available for this patch.')
        break
      }
      spt <- sample(edg, 1)
    } else {
      mtx[ad] <- val
      edg <- c(edg[edg != spt], ad)
      cg <- cg + length(ad)
      spt <- ifelse(length(edg) == 1, edg, sample(edg, 1) )
    }
  }
  if(rast == TRUE) {
    context[] <- t(mtx)
    return(context)
  } else if (edge == TRUE) {
    edgVal <- ifelse(val+1 == bgr, val+2, val+1)
    mtx[edg] <- edgVal
    edg <- which(mtx == edgVal)
    idx <- which(mtx == val)
    return(list(inner = idx, edge = edg))
  } else {
    return( which(mtx == val))
  }
}

## Converts matrix of coordinates into cell number
.toCellIndex <- function(rast, coord) {
  if(is.vector(coord)){
    coord
  } else if(is.matrix(rast)){
    stop('Cannot use spatial coordinates on a matrix. Please provide a raster or a vector of cell indexes.')
  } else {
    raster::cellFromXY(rast, coord)
  }
}


## Find contiguous cells (rook case, 4 directions)
.contigCells <- function(pt, dim1, dim2){
  if(pt %% dim1 == 0){
    rr <- dim1
    cc <- pt / dim1
  } else {
    cc <- trunc(pt / dim1) + 1
    rr <- pt - (cc-1) * dim1
  }
  ad <- c(rr-1, rr+1, rr, rr, cc, cc, cc-1, cc+1)
  ad[ad <= 0 | c(ad[1:4] > dim1, ad[5:8] > dim2)] <- NA
  ad <- ad[1:4] + (ad[5:8]-1)*dim1
  ad[!is.na(ad)]
}

## Converts matrix indexes into indexes suitable for the transposed matrix (NOT USED)
.indexTranspose <- function(mtx, id){
  dim1 <- dim(mtx)[1]
  dim2 <- dim(mtx)[2]
  sapply(id, function(x){
    if(x %% dim1 == 0){
      rr <- dim1
      cc <- x / dim1
    } else {
      cc <- trunc(x / dim1) + 1
      rr <- x - (cc - 1) * dim1
    }
    cc + (rr-1) * dim2
  })
}
