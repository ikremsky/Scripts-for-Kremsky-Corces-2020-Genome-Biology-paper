file1=$1 
file2=$2
intersectFile=$3
IDRFile=$4
name1=$5
name2=$6
id=$7

file1Count=$(wc -l $file1 | cut -f1 -d" ") 
echo $IDRFile
file2Count=$(wc -l $file2 | cut -f1 -d" ")
echo $intersectFile 
intersectCount=$(wc -l $intersectFile | cut -f1 -d" ")
IDRcount=$(wc -l $IDRFile | cut -f1 -d" ")
name=$(echo "$name1 $name2" | awk '{gsub("Rep1", ""); gsub("Rep2", ""); print}' | awk '{if($1 == $2) print $1; else print $1"_"$2}')

R --vanilla --args $file1Count $file2Count $intersectCount "${name1}" "${name2}" "${name}_${id}_overlaps.png" < drawPairwiseVenn.R
#R --vanilla --args $file1Count $file2Count $IDRcount "${name1}" "${name2}" "${name}_${id}_IDR.png" < drawPairwiseVenn.R
echo $name
