cat trait_list.par | while read line; do
g=`echo $line | awk '{ print $1 }'`
n=`echo $line | awk '{ print $2 }'`
sbatch -n 1 -p short -t 04:00:00 --mem-per-cpu=8G --array=1-22 --job-name="h2" TEST.sh $g $n
done
