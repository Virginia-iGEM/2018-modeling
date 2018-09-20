#!/bin/bash
#SBATCH -N 1                 # Number of nodes
#SBATCH --ntasks-per-node=1  # Number of cores
#SBATCH -t 168:00:00          # Runtime - job will be killed after this
#SBATCH -A virginia_igem     # Our allocation - don't change this
#SBATCH -p standard          # Node type - you shouldn't have a reason to change
#SBATCH --output=output.txt  # stdout is piped to this file

# Run program
module load matlab
cd $SLURM_SUBMIT_DIR
date
matlab -nojvm -nodisplay -nosplash -singleCompThread -r  "clear;Model_Population('Rivanna09');exit"
date
