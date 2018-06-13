DAT=$1
NAME=$2
NORM=$3

cat $DAT \
| awk '{ print NR,$2,$3,$19 }' \
| sort -k3,3 -k1,1g \
| awk -vn=$NORM -vd="$NAME" 'BEGIN{prev=""} { if($3 != prev) { if(prev!="") { cur_str = d" | "sprintf("%2.1f",sum/tot/n)" | "sprintf("%2.1f",sum/tot)" | "sprintf("%2.1f",max)" "cur_str; print cur_str >> "genes/"prev".md"; } max=0; sum=0; tot=0; cur_str = ""; } cur_str = cur_str" | "sprintf("%2.1f",$4); if(max < $4^2) max=$4^2; sum += $4^2; tot++; prev=$3 } END { print cur_str >> "genes/"prev".md" }'
