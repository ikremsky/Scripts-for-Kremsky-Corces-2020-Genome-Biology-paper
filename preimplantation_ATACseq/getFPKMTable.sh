#rm FPKMtable_ICM_accessible_inaccessible.txt
for file in 
#$(ls bed_TFs_allstrains/*/ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_*.Hi.fpkm)
do
	TF=$(basename $file .Hi.fpkm | cut -f3 -d"_")
	loFile=$(echo $file | awk '{sub(".Hi.fpkm", ".Lo.fpkm"); print}')
	echo $TF $(wc -l $file | cut -f1 -d" ") $(wc -l $loFile | cut -f1 -d" ") >> FPKMtable_ICM_accessible_inaccessible.txt
done

rm FPKMtable_ICM_accessible_inaccessible_distal.txt
for file in $(ls bed_TFs_allstrains/*/ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_*.distalHi.fpkm)
do
        TF=$(basename $file .distalHi.fpkm | cut -f3 -d"_")
        loFile=$(echo $file | awk '{sub("Hi.fpkm", "Lo.fpkm"); print}')
        echo $TF $(wc -l $file | cut -f1 -d" ") $(wc -l $loFile | cut -f1 -d" ") >> FPKMtable_ICM_accessible_inaccessible_distal.txt
done

