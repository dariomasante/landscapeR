#include <Rcpp.h>
using namespace Rcpp;

// Get contiguous cells (rook case only)

// [[Rcpp::export(name = ".contigCells")]]
IntegerVector contigCells_cpp(int pt, int bgr, NumericMatrix mtx) {
  int rr;
  int cc;
  int dim1 = mtx.nrow();
  int dim2 = mtx.ncol();
  IntegerVector r(4);
  IntegerVector c(4);
  IntegerVector ad;
  int idx;
  if (pt % dim1 == 0) {
    rr = dim1;
    cc = pt / dim1;
  } else {
    cc = trunc(pt / dim1) + 1;
    rr = pt - (cc-1) * dim1;
  }
  r[0] = rr-1;
  r[1] = rr+1;
  r[2] = rr;
  r[3] = rr;
  c[0] = cc;
  c[1] = cc;
  c[2] = cc-1;
  c[3] = cc+1;
  for (int i = 0; i < 4; i++){
    if(r[i] > 0 && r[i] <= dim1 && c[i] > 0 && c[i] <= dim2){
      idx = r[i] + (c[i] - 1) * dim1;
      if(mtx[idx-1] == bgr){
        ad.push_back(idx);
      }
    }
  }
  return(ad);
}

// Transpose index of input cells

// [[Rcpp::export(name = ".indexTranspose")]]
IntegerVector indexTranspose_cpp(IntegerVector id, int dim1, int dim2) {
  int n = id.size();
  int rr = 0;
  int cc = 0;
  IntegerVector out(n);
  for (int i = 0; i < n; i++){
    if(id[i] % dim1 == 0){
      rr = dim1;
      cc = id[i] / dim1;
    } else {
      cc = trunc(id[i] / dim1) + 1;
      rr = id[i] - (cc - 1) * dim1;
    }
    out[i] = cc + (rr-1) * dim2;
  }
  return(out);
}

