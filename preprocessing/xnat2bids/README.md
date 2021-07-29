# XNAT2BIDS

Import data from XNAT and convert it to BIDS format.

We use the BNC-maintained Singularity container in Oscar of [`xnat-tool`](https://github.com/brown-bnc/xnat-tools). To learn more, see the [docs](https://docs.ccv.brown.edu/bnc-user-manual/export-xnat-to-bids-format/getting-started)

## `run_xnat2bids.sh`

Main batch script. 
To chage/specify participant you need to modify the line including

```
#SBATCH --array=111,002
```

You can specify one or many. However, XNAT only supports a given number of simultaneous connections so don't go crazy ;)

For each participant make sure to also add entries to the following lines

```bash
#----------- Dictionaries for subject specific variables -----
# Dictionary of sessions to subject
declare -A sessions=([111]="XNAT_E00008" \
                     [002]="XNAT13_E00011")

# Dictionary of series to skip per subject
declare -A skip_map=([111]="-s 6" \
                     [135]="-s 6")

```

### Passing your password to the batch script

In order to download data from XNAT, you need to pass the script your Brown password. DO NOT store your password on scripts, the recommended way is to get a temporary token and save it in a `.env` file that is not under version control (that is `.env` is listed inside your `.gitignore` file).

To get a temporary token/password you can run a convinienc escript that we have created for you. i.e,

```
/gpfs/data/bnc/scripts/xnat-token -u <xnatuser>
```

This script will print something like

```
XNAT_USER=xxxxxxxxxx
XNAT_PASSWORD=xxxxxxxx
```

You can pase such content into your `.env` file