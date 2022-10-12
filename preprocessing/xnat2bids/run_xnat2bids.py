#!/usr/bin/env python
import os
from simple_slurm import Slurm
import datetime
import getpass

#-----------------  user-variables  -----------------
USER_NAME = getpass.getuser()
USER_PASSWORD = getpass.getpass("Enter Password for User Name : %s" %USER_NAME)

#-------------------  xnat-tools  -------------------
# version of xnat2bids being used
xnat_tools_version = "v1.0.5"
# Path to Singularity Image for xnat-tools (maintained by bnc)
simg=f"/gpfs/data/bnc/simgs/brownbnc/xnat-tools-{xnat_tools_version}.sif"

#---------------  Output Directory  ---------------
bids_output_dir=f"/gpfs/home/{USER_NAME}/xnat-exports"
if os.path.exists(bids_output_dir):
  print ("bids root directory already exists")  
else:
  os.mkdir(bids_output_dir)


#----- Dictionaries for subject specific variables -----
# Dictionary of sessions to subject
sessions = {"111":"XNAT_E00008", "002":"XNAT13_E00011"}
# Dictionary of series to skip per subject
skip_map = {"111":"-s 1 -s 2 -s 3 -s 4 -s 5 -s 11", "002":"-s 6"}

#Use the array ID to get the right value for this job
# sessions
XNAT_SESSION=sessions["002"]
SKIP_STRING=skip_map["002"]


#----------------- Run xnat2bids ----------------
slurm = Slurm(
    cpus_per_task=1,
    mem=4000,
    nodes=1,
    job_name='slurmTest',
    output=f'/gpfs/scratch/{Slurm.USER_NAME}/test.log',
    time=datetime.timedelta(days=0,hours=2,minutes=0,seconds=0),
 )

# runs singularity command to extract DICOMs from xnat and export to BIDS
# this command tells singularity to launch out xnat-tools-${version}.sif image
# and execute the xnat2bids command with the given inputs.
# The `-B` flag, binds a path. i.e, makes that directory available to the singularity container
# The file system inside your container is not the same as in Oscar, unless you bind the paths
# The -i passes a sequence to download, without any -i all sequences will be processed

# use -i to process one specific sequence.
#slurm.sbatch('singularity exec --no-home --bind %s %s xnat2bids %s %s -u %s -p %s -i 1 --overwrite' %(bids_output_dir,simg,XNAT_SESSION,bids_output_dir,USER_NAME,USER_PASSWORD))

slurm.sbatch('singularity exec --no-home -B %s %s xnat2bids %s %s -u %s -p %s --overwrite %s' %(bids_output_dir,simg,XNAT_SESSION,bids_output_dir,USER_NAME,USER_PASSWORD,SKIP_STRING))
