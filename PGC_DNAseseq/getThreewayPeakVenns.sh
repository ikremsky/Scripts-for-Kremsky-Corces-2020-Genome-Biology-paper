file1=$1 
file2=$2
intersectFile12=$3
IDRFile=$4
name1=$5
name2=$6
id=$7
file3=$8
intersectFile13=$9
intersectFile23=$10
name3=$11
intersectFile123=$12


file1Count=$(wc -l $file1 | cut -f1 -d" ") 
file2Count=$(wc -l $file2 | cut -f1 -d" ")
file3Count=$(wc -l $file3 | cut -f1 -d" ")
intersect12Count=$(wc -l $intersectFile12 | cut -f1 -d" ")
intersect13Count=$(wc -l $intersectFile13 | cut -f1 -d" ")
intersect23Count=$(wc -l $intersectFile23 | cut -f1 -d" ")
intersect123Count=$(wc -l $intersectFile123 | cut -f1 -d" ")
IDRcount=$(wc -l $IDRFile | cut -f1 -d" ")
name=$(echo "$name1 $name2" | awk '{gsub("Rep1", ""); gsub("Rep2", ""); print}' | awk '{if($1 == $2) print $1; else print $1"_"$2}')

R --vanilla --args $file1Count $file2Count $intersect12Count "${name1}" "${name2}" "${name}_${id}_overlaps.png" $file3Count $intersect13Count $intersect23Count "${name3}" $intersect123Count < drawThreewayVenn.R
echo $name
