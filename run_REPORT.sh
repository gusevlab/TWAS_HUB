sbatch -n 1 -p short -t 08:00:00 --mem-per-cpu=8G --job-name="report" --array=1-324 REPORT.sh
