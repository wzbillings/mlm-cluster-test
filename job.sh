#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=test
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4

module load R/4.4.2
Rscript model-fitting.R
