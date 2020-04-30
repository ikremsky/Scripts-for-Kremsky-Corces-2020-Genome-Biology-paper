for folder in $(ls -d motifAnalysis_E7.5meHi_*/)
do
	awk 'NR%2 == 0 && $NF < .001 && $3 > $4' ${folder}summary.txt | cut -f1 | grep -v ":" | awk '{print toupper($1)}' | sort -b | uniq > ${folder}allSignificant.txt
done

file1=motifAnalysis_E7.5meHi_IntestinemeLo/allSignificant.txt
file2=motifAnalysis_E7.5meHi_heartmeLo/allSignificant.txt
file3=motifAnalysis_E7.5meHi_forebrainmeLo/allSignificant.txt
name1=Intestine
name2=Heart
name3=Forebrain

join $file1 $file2 > intersectFile12
join $file1 $file3 > intersectFile13
join $file2 $file3 > intersectFile23
join intersectFile12 intersectFile23 > intersectFile123

file1Count=$(wc -l $file1 | cut -f1 -d" ") 
file2Count=$(wc -l $file2 | cut -f1 -d" ")
file3Count=$(wc -l $file3 | cut -f1 -d" ")
intersect12Count=$(wc -l intersectFile12 | cut -f1 -d" ")
intersect13Count=$(wc -l intersectFile13 | cut -f1 -d" ")
intersect23Count=$(wc -l intersectFile23 | cut -f1 -d" ")
intersect123Count=$(wc -l intersectFile123 | cut -f1 -d" ")
name=$(echo "$name1 $name2 $name3" | awk '{print $1"_"$2"_"$3}')

R --vanilla --args $file1Count $file2Count $intersect12Count "${name1}" "${name2}" "${name}_overlaps.png" $file3Count $intersect13Count $intersect23Count "${name3}" $intersect123Count < drawThreewayVenn.R
echo $name
