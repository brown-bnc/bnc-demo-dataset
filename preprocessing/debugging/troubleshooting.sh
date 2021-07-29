
# version of xnat2bids being used
version=v1.0.2
simg=/gpfs/data/bnc/simgs/brownbnc/xnat-tools-${version}.sif

#Invoke shell
singularity shell ${simg}

# -------
version=v0.1.1
simg=/gpfs/data/bnc/simgs/brownbnc/xnat-tools-${version}.sif

#Invoke shell
singularity exec ${simg} heudiconv --version
singularity exec ${simg} dcm2niix --version