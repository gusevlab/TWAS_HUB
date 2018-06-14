# TWAS HUB

Code for running large-scale TWAS analyses and producing static Markdown reports.

## Workflow:

* `mkdir genes traits tmp`
* Submit `TWAS.sh` jobs for each trait x chromosome in parallel (see example `run_TWAS.sh`)
* Run `MERGE.sh` to combine all files and generate info files
* Submit `REPORT.sh` for each trait (see example `run_REPORT.sh`)
* Run `Rscript REPORT_GENES.R` to scan through all traits and build individual gene reports (this takes a few hours) 
* Run `Rscript REPORT_INDEX.R` to generate all index files (fast)
