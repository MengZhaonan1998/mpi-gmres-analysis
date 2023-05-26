#!/bin/bash

# run all benchmarks, defined in .slurm files

#echo "COMMUNICATION BENCHMARKS:"
#for processes in 150 100 64 48 36 18 12 4; do
#	nodes=$(((processes-1)/48+1))
#	if (( nodes > 1 )); then
#		echo "With $processes processes, $nodes nodes:"
#		sbatch -o slurm-communication-$processes-$$.out -n $processes -N $nodes research_account_communication_benchmarks.slurm
#	else
#		echo "With $processes processes:"
#		sbatch -o slurm-communication-$processes-$$.out -n "$processes" communication_benchmarks.slurm
#	fi
#done

echo "POLYNOMIAL PRECONDITIONER BENCHMARKS:"
for processes in 48; do
	echo "With $processes processes:"
	sbatch -o slurm-precond-$processes-$$.out -n "$processes" precond_benchmarks.slurm
done
