#pragma once

#include <sstream>
#include <stdexcept>
#include <mpi.h>

// struct to represent a 3D 7-point stencil:
//
//          T  N
//          | /
//          |/
//      W---C---E
//         /|
//        / |
//       S  B
//
//   _ 
// ^ /y
//z|/  
// +-->
//   x 
//
typedef struct stencil3d
{
  // grid dimensions
  int nx, ny, nz;
  // multiplication factors when applying the stencil
  // (=sparse matrix  entries)
  double value_c, value_n, value_e, value_s, value_w, value_b, value_t;

  ////////////////////////
  // indexing functions //
  ////////////////////////

  //return the position in a vector where grid cell (i,j,k) is located
  inline int index_c(int i, int j, int k) const
  {
    if (i<0 || i>=nx || j<0 || j>=ny || k<0 || k>=nz)
    {
      std::stringstream ss;
      ss << "stencil3d index ("<<i<<","<<j<<","<<k<<") outside range ("<<nx<<","<<ny<<","<<nz<<")";
      throw std::runtime_error(ss.str());
    }
    return (k*ny +j)*nx + i;
  }

  //return the position in a vector where grid cell (i,j+1,k) is located
  inline int index_n(int i, int j, int k) const {return index_c(i,   j+1, k);};
  //return the position in a vector where grid cell (i+1,j,k) is located
  inline int index_e(int i, int j, int k) const {return index_c(i+1, j,   k);};
  //return the position in a vector where grid cell (i,j-1,k) is located
  inline int index_s(int i, int j, int k) const {return index_c(i,   j-1, k);};
  //return the position in a vector where grid cell (i-1,j,k) is located
  inline int index_w(int i, int j, int k) const {return index_c(i-1, j,   k);};
  //return the position in a vector where grid cell (i,j,k+1) is located
  inline int index_b(int i, int j, int k) const {return index_c(i,   j, k-1);};
  //return the position in a vector where grid cell (i,j,k-1) is located
  inline int index_t(int i, int j, int k) const {return index_c(i,   j, k+1);};

} stencil3d;

typedef struct block_params
{
  //number of blocks in x, y and z directions
  int bkx, bky, bkz;
  //index in x, y and z direction of this block
  int bx_idx, by_idx, bz_idx;
  // grid dimensions
  int bx_sz, by_sz, bz_sz;
  // neighbour ranks
  int rank_e, rank_w, rank_n, rank_s, rank_b, rank_t;
} block_params;

//////////////////////////////////
// Linear operator application  //
//////////////////////////////////

// apply a 7-point stencil to a vector, v = op*x
void apply_stencil3d(stencil3d const* op, block_params const* bp, double const* u, double* v);

//////////////////////////////////
// Blocking operator            //
//////////////////////////////////
block_params create_blocks(int nx, int ny, int nz);

//////////////////////////////////
// Vector operations            //
//////////////////////////////////
//
// initialize a vector with a constant value, x[i] = value for 0<=i<n
void init(block_params const* bp, double* x, double const value);

// scalar product: return sum_i x[i]*y[i] for 0<=i<n
double dot(block_params const* bp, double const* x, double const* y);

// vector update: compute y[i] = a*x[i] + b*y[i] for 0<=i<n
void axpby(block_params const* bp, double a, double const* x, double b, double* y);

