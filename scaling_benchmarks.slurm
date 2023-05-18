#!/bin/sh

#SBATCH --exclusive
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=0
#SBATCH --account=education-eemcs-courses-wi4450
#SBATCH --reservation=wi4450
#SBATCH --time=00:10:00

# run GMRES for different sizes of Poisson problem
srun ./main_gmres_poisson_cart.x 100 100 100
srun ./main_gmres_poisson_cart.x 200 100 100
srun ./main_gmres_poisson_cart.x 400 100 100
srun ./main_gmres_poisson_cart.x 800 100 100
srun ./main_gmres_poisson_cart.x 1600 100 100
