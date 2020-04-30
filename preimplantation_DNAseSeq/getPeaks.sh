peakFile=peaks
mkdir $peakFile
cd $peakFile

for file in /hdisk6/yoonhee/Downloads/GSE76642_GVooyte_PN5_DnaseSeq_Cell_2016/Pronuclei_Mat_PN5_Dnase-seq_sort_rmdup.bam
do
	echo $file
#       macs2 callpeak -p .05 --keep-dup all -g mm -f BAMPE -t $file -n $(basename $file .sorted.bam) 
	 macs -t $file -f BAM -g mm -n $(basename $file .bam)
done
