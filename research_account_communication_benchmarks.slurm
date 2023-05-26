#!/bin/sh

#SBATCH --exclusive
#SBATCH -c 1
#SBATCH --mem=0
#SBATCH --account=research-eemcs-diam
#SBATCH --time=00:10:00

# run GMRES for a n^3 Poisson problem
n=600
srun ./main_gmres_poisson_global.x $n
srun ./main_gmres_poisson_win.x $n
srun ./main_gmres_poisson_cart.x $n
