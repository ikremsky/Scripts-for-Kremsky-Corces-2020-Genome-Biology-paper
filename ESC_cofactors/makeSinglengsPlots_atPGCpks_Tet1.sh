type=Tet1
bamFile=/Zulu/isaac/ChIPseq_Tet1_ESCs/bam/WTTet1_Flag_ChIPSeq.SRR5812872.trim.sorted.duprmvd_distal.bam
awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,$4,$5,$6}' /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm > test.bed
uniqueBed=test.bed

ctrlBamFile=$bamFile
awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,$4,$5,$6}' /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm > ctr.bed
ctrlBed=ctr.bed
testLab="E14.5m_DNAse-Hi"
ctrlLab="E14.5m_DNAse-Lo"
color="red"
ctrlColor="black"
macs2 predictd -i $bamFile 2> $(basename $bamFile .bam).fraglen.txt &
if [ $(echo "$bamFile $ctrlBamFile" | awk '{if($1 == $2) x=1; else x=0; print x}') -eq 0 ]; then
#	macs2 predictd -i $ctrlBamFile 2> $(basename $ctrlBamFile .bam).fraglen.txt &
	wait
	ctrlfl=$(grep "predicted fragment length is" $(basename $ctrlBamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
	fl=$(grep "predicted fragment length is" $(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
	echo "different bam files"
else
	wait
	fl=$(grep "predicted fragment length is" $(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
	ctrlfl=$fl
fi

echo "${bamFile} ${uniqueBed} ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_${type}.txt
echo "${ctrlBamFile} ${ctrlBed} ${ctrlLab} ${ctrlfl} $ctrlColor" | awk '{gsub(" ", "\t"); print}' >> configurationFile_${type}.txt
cat configurationFile_${type}.txt
ngs.plot.r -GO none -MQ 2 -G mm9 -R bed -C configurationFile_${type}.txt -F chipseq -XYL 0 -RB .01 -L 5000 -FS 20 -O ${type}_atPGCpks
cat configurationFile_${type}.txt
rm configurationFile_${type}.txt
