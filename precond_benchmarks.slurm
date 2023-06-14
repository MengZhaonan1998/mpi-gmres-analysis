#!/bin/sh

#SBATCH --exclusive
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=0
#SBATCH --account=education-eemcs-courses-wi4450
#SBATCH --reservation=wi4450
#SBATCH --time=00:30:00

n=100
for degree in 2 3 4 5 8 13 16 21 34 55 76 89 144; do
		srun ./main_polyg_poisson_cart.x $n $degree
done
n=200
for degree in 2 3 4 5 8 13 16 21 34 55 76 89 144 233; do
		srun ./main_polyg_poisson_cart.x $n $degree
done
n=500
for degree in 2 3 4 5 8 13 16 21 34 55 76 89 144 233; do
		srun ./main_polyg_poisson_cart.x $n $degree
done
