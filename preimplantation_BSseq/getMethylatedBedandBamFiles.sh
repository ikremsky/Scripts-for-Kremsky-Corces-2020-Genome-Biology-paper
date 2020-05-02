mkdir bam

for file in $(ls bed/*mm9.bed | grep -v sperm | grep -v paternal | grep -v maternal)
do
	awk '$5 > .5' $file > $(echo $file | awk '{gsub(".bed", ".me.5.bed"); print}') &





#	bedToBam -i $(echo $file | awk '{gsub(".bed", ".me.5.bed"); print}') -g /home/genomefiles/mouse/mm9.chrom.sizes > bam/$(basename $file .bed).bam &
#	samtools sort bam/$(basename $file .bed).bam > bam/$(basename $file .bed).sorted.bam &
#	samtools index -b bam/$(basename $file .bed).sorted.bam
done
wait

