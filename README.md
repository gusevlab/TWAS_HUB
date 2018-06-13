# TWAS HUB

Code for running large-scale TWAS analyses and producing static Markdown reports.

## Workflow:

0. `mkdir genes traits tmp`
1. Submit `TWAS.sh` jobs for each trait x chromosome in parallel (see example `run_TWAS.sh`)
2. Run `MERGE.sh` to combine all files and generate info files
3. Submit `REPORT.sh` for each trait (see example `run_REPORT.sh`)
4. Run `Rscript REPORT_GENES.R` to scan through all traits and build individual gene reports (this takes a few hours) 
5. Run `Rscript REPORT_INDEX.R` to generate all index files (fast)
