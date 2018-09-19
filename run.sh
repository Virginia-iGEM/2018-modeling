#!/bin/bash
#SBATCH -N 1                 # Number of nodes
#SBATCH --ntasks-per-node=1  # Number of cores
#SBATCH -t 00:05:00          # Runtime - job will be killed after this
#SBATCH -A virginia_igem     # Our allocation - don't change this
#SBATCH -p standard          # Node type - you shouldn't have a reason to change
#SBATCH --output=output.txt  # stdout is piped to this file

# Run program
module load matlab
cd $SLURM_SUBMIT_DIR
matlab -nojvm -nodisplay -nosplash -singleCompThread -r  "RunFunction(inputs);exit"