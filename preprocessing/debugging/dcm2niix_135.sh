#!/bin/bash
#SBATCH -t 04:00:00
#SBATCH --mem=16GB
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -J dcm2nii
#SBATCH -o /gpfs/scratch/%u/logs/dcm2nii-%A_%a.out
#SBATCH --array=135

#--------- Variables ---------
# This line makes our bash script complaint if we have undefined variables
set -u

# version of xnat2bids being used
version=v1.0.2


data_dir=/gpfs/data/bnc

# Output directory
input_dir=${data_dir}/shared/bids-export/mrestrep/sanes/study-sadlum/xnat-export/sub-135/ses-01/func-bold_task-lum_run-01
output_dir=/gpfs/scratch/${USER}/dcm2niix/${SLURM_ARRAY_TASK_ID}
mkdir -m 775 ${output_dir} || echo "Output directory already exists"


# Path to Singularity Image for xnat-tools (maintained by bnc)
simg=/gpfs/data/bnc/simgs/brownbnc/xnat-tools-${version}.sif

# Read variables in the .env file in current directory
# This will read:
# XNAT_USER, XNAT_PASSWORD
set -a
[ -f .env ] && . .env
set +a


singularity exec --contain -B ${input_dir}:/input:ro -B ${output_dir}:/output ${simg} \
    dcm2niix -b y -z y -x n -t n -m n -f func -o /output -s n -v n /input