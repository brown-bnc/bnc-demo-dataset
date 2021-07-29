# XNAT2BIDS

Import data from XNAT and convert it to BIDS format.

We use the BNC-maintained Singularity container in Oscar of [`xnat-tool`](https://github.com/brown-bnc/xnat-tools). To learn more, see the [docs](https://docs.ccv.brown.edu/bnc-user-manual/export-xnat-to-bids-format/getting-started)

* `run_xnat2bids.sh`

Main batch script. 
To chage/specify participant you need to modify the line including

```
#SBATCH --array=135,137
```

You can specify one or many. However, XNAT only supports a given number of simultaneous connections so don't go crazy ;)

For each participant make sure to also add entries to the following lines

```bash
#----------- Dictionaries for subject specific variables -----
# Dictionary of sessions to subject
declare -A sessions=([137]="XNAT3_E00035" \
                     [135]="XNAT3_E00013")

# Dictionary of series to skip per subject
declare -A skip_map=([137]="-s 6 -s 15 -s 16 -s 17 -s 18" \
                     [135]="-s 6 -s 8 -s 15 -s 16 -s 17 -s 18")

```