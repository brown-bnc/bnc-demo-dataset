#!/bin/bash
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=30G
#SBATCH --time 18:00:00
#SBATCH -J fmriprep
#SBATCH -o /gpfs/scratch/%u/logs/fmriprep-%A_%a.out
#SBATCH --array=135,137

#--------- set up directories ---------
# Your working directory in Oscar, usually /gpfs/data/<your PI's group>.
data_dir=/gpfs/data/bnc
investigator=sanes
study_label=sadlum

# Output directory
# It has to be under the data_dir, otherwise it won't be seen by singularity
root_dir=${data_dir}/shared/bids-export/${USER}
bids_dir=${root_dir}/${investigator}/study-${study_label}/bids

#--------- paticipant specific variables ---------
participant_label=${SLURM_ARRAY_TASK_ID}

#--------- fmriprep version and image ---------
# version of xnat2bids being used
version=20.1.2
# Path to Singularity Image for fmriprep (maintained by bnc)
simg=/gpfs/data/bnc/simgs/poldracklab/fmriprep-${version}.sif

#-----------run fMRIPrep without freesurfer option
singularity run \
--bind ${bids_dir}:/bids \
--bind /gpfs/scratch/${USER}:/scratch \
--bind /gpfs/data/bnc/licenses:/licenses:ro ${simg}  \
/bids /bids/derivatives/fmriprep-${fmriprep_version}-nofs \
participant --participant-label ${participant_label}                 \
--fs-license-file /licenses/freesurfer-license.txt --fs-no-reconall   \
-w /scratch/fmriprep --stop-on-first-crash                            \
--omp-nthreads 16 --nthreads 16
