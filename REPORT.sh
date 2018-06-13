#!/bin/sh
R --slave --args ${SLURM_ARRAY_TASK_ID} < REPORT_SINGLE.R
