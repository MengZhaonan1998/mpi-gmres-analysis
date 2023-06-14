# Parallel GMRES with Polynomial Preconditioning
Welcome to mpi-gmres-analysis! This repository contains an implementation of the Generalized Minimal Residual (GMRES) method with a polynomial preconditioner. The GMRES algorithm is parallelized using the Message Passing Interface (MPI).

## Introduction
The Generalized Minimal Residual (GMRES) method is an iterative technique widely employed for solving large sparse linear systems. We have utilized it to address a 3D convection-diffusion problem
$$-\Delta u + \frac{\partial u}{\partial x}=f,\quad (x,y,z)\in[0,1]^3,$$
$$u(x,y,0)=g(x,y), \quad (x,y)\in[0,1]^2,$$
$$u(x,y,z)=0, \quad \text{elsewhere on boundary},$$
where 
$$f(x,y,z)=z\sin(2\pi x)\sin(\pi y)+8z^3,$$
$$g(x,y)=x(1-x)y(1-y).$$
We have employed a finite difference method stencil (i.e. we implement the matrix-vector multiplication in matrix-free) and a parallel GMRES solver using MPI. To increase the convergence speed, a polynomial preconditioner in conjunction with diagonal scaling was used. The truncated Neumann series $P_n(A)$ can be used as a polynomial preconditioner which is defined as
$$P_n(A)=\sum_{k=0}^n(I-A)^k \approx A^{-1}.$$

## Building the Project
### Prerequisites
To build and run the parallel GMRES implementation, you need to have the following dependencies installed:
1. MPI Library
2. The compiler: mpic++17

### Building Steps
1. Clone the repository to your local machine: 
   ```bash
   git clone https://github.com/eliasstenhede/mpi-gmres-analysis.git
2. Navigate to the project directory:
   ```bash
   cd mpi-gmres-analysis
3. Compile the source code using the provided Makefile:
   ```bash
   make
