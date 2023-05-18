#include "timer.hpp"
#include "operations.hpp"
#include "solver.hpp"

#include <cmath>
#include <stdexcept>
#include <iostream>
#include <iomanip>

void jacobi_solver(stencil3d* op, block_params const* BP, int n, double* x, double const* b,
	           double tol, int maxIter, double* resNorm, int* numIter, int verbose)
{
   if (op->nx * op->ny * op->nz != n)
   {
      throw std::runtime_error("mismatch between stencil and vector dimension passed to jacobi_solver");
   }

   int rank;
   MPI_Comm_rank(MPI_COMM_WORLD, &rank);

   double aii = op->value_c;   // diagonal entry aii of stencil 
   op->value_c = 0.0;          // eliminate the diagonal entry

   double* r = new double[n];  // residual vector
   double* y = new double[n];  // used to store some intermidiate results
  
   double r_norm;              // residual norm
   double b_norm;              // right hand side b norm

   // r=b-A*x
   apply_stencil3d(op, BP, x, r);  // r = op * x
   axpby(n, 1.0, b, -1.0, r);      // r = b - r

   // compute the error
   r_norm = std::sqrt(dot(n,r,r)); // 2-norm of r
   b_norm = std::sqrt(dot(n,b,b)); // 2-norm of b
   double error = r_norm/b_norm;   // relative error

   // start jacobi iteration
   int iter = -1;
   while (true)
   {
      Timer t("jacobi iteration");
      iter++;

      if (verbose && rank==0 && iter%50==0)
         std::cout << std::setw(4) << iter << "\t" << std::setw(8) << std::setprecision(4) << error << std::endl;
      
      // check for convergence or failure
      if ( (error < tol) || (iter == maxIter) )
        break;
      
      // jacobi iteration
      op->value_c = 0.0;                        // eliminate the diagonal entry
      apply_stencil3d(op, BP, x, y);            // y=(L+U)*x  
      axpby(n, 1.0, b, -1.0, y);                // y=b-y
      for (int i=0; i<n; i++) x[i] = y[i]/aii;  // x = D^-1*y
      
      // compute error
      op->value_c = aii;
      apply_stencil3d(op, BP, x, r);    // r = op * x
      axpby(n, 1.0, b, -1.0, r);        // r = b - r
      r_norm = std::sqrt(dot(n,r,r));   // 2-norm of r
      error = r_norm/b_norm;            // relative error
   }

   if (verbose && rank==0)
      std::cout << std::setw(4) << iter << "\t" << std::setw(8) << std::setprecision(4) << error << std::endl;   

   *resNorm = error;
   *numIter = iter;

   delete [] r;
   delete [] y;
}
