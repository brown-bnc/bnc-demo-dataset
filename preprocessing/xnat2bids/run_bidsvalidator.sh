#!/bin/bash
#SBATCH -t 01:00:00
#SBATCH --mem=16GB
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -J bids-validator
#SBATCH -o /gpfs/scratch/%u/logs/bids-validator-%j.out

# latest versions as of 7.28.21
version=v1.7.2

# Directory containing the dataset_description.json
bids_directory=/gpfs/data/bnc/shared/bids-export/bnc/study-demodat/bids
simg=/gpfs/data/bnc/simgs/bids/validator-${version}.sif

# The following command runs the bids-validator executable (via singularity)
# to test if a directory is BIDS compliant. 
# The command tells singularity to launch validator-${version}.sif image 
# and execute the bids-validator command. 
# The bids validator expects the a directory as an input, 
# which in this case corresponds to ${bids_directory}. 
# The --bind ${bids_directory}:ro makes the data_dir directory available
# to the singularity container as read-only. 
singularity exec --bind ${bids_directory} ${simg} \
bids-validator ${bids_directory}

