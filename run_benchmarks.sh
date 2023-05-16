#!/bin/bash

#Scaling benchmarks
echo "With 32 processes, scaling benchmark:"
sbatch -o slurm-scaling-32-$$.out -n 32 scaling_benchmarks.slurm

args=(80 64)
for arg in "${args[@]}"; do
		echo "With $arg processes:"
		sbatch -o slurm-communication-$arg-$$.out -n $arg research_account_communication_benchmarks.slurm
done
args=(48 36 27 18 12 8 4 2 1)
for arg in "${args[@]}"; do
		echo "With $arg processes:"
    sbatch -o slurm-communication-$arg-$$.out -n "$arg" communication_benchmarks.slurm
    sbatch -o slurm-precond-$arg-$$.out -n "$arg" precond_benchmarks.slurm
done

