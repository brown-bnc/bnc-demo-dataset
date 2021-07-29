# FMREPREP

Run `fmriprep`.

We use the BNC-maintained Singularity container in Oscar of fmriprep.

* `run_fmriprep.sh`

Main batch script. 
To change/specify participant you need to modify the line including

```
#SBATCH --array=135,137
```

You can specify one or many. 

The sample script is running FreeSurfer