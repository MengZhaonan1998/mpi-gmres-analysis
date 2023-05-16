#!/bin/sh

#SBATCH --exclusive
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=0
#SBATCH --account=education-eemcs-courses-wi4450
#SBATCH --reservation=wi4450
#SBATCH --time=00:10:00

# run GMRES for a n^3 Poisson problem
n=100

srun ./main_polyg_poisson_cart.x $n 1
srun ./main_polyg_poisson_cart.x $n 2
srun ./main_polyg_poisson_cart.x $n 3
srun ./main_polyg_poisson_cart.x $n 4
srun ./main_polyg_poisson_cart.x $n 5
srun ./main_polyg_poisson_cart.x $n 6

#TODO benchmark this one
#srun ./main_diagg_poisson_cart.x $n
