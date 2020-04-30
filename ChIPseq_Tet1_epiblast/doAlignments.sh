outDir=sam
bamoutDir=bam
mkdir $outDir $bamoutDir

align () {
       	zcat $file | bowtie -t -m 1 -p 16 --mapq 254 -S /home/genomefiles/mouse/mm9/chromosomes_combined/mm9 - ${outDir}/${outName}.sam > ${outDir}/${outName}.txt 2>&1
        samtools view -b ${outDir}/${outName}.sam > ${bamoutDir}/${outName}.bam

#       bowtie2 -p 16 --no-mixed --no-discordant -x /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes -U ${file} -S ${outDir}/${outName}.sam > ${outDir}/${outName}.txt 2>&1
#       grep -v "XS:i:" ${outDir}/${outName}.sam | samtools view -b -hf 0x2 - > ${bamoutDir}/${outName}.bam
#       /programs/SNPsplit/SNPsplit --snp_file /hdisk2/isaac/isaachd/ATAC-seq_naturedata/SNPs/v5/all_PWK_PhJ_SNPs_C57BL_6NJ_reference.based_on_mm9.txt --paired ${bamoutDir}/${outName}.bam
}

i=1
for treat in E14_Ash2L_GFP E14_Cxxc1_GFP  E14_empty_GFP E14_Mll2FL_N_GFP_FCS_LIF_2i E14_MLL2_N_GFP
do
	files=$(ls fastq/${treat}*trim*gz)
	outName=$treat
	j=1
	for file in $files
	do
		echo $file
		outName=${treat}_$j
	        if [ $(echo $i | awk '{print $1%40}') -eq 0 ]; then
	                wait
	        fi
	        align &
	        i=$(expr $i + 1)
		j=$(expr $j + 1)
	done
done
wait
echo done
