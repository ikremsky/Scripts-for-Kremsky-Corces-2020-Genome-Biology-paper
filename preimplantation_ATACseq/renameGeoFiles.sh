#First download metadata table from http://www.ncbi.nlm.nih.gov/Traces/study/?acc=GSE66581&go=go

for file in $(ls fastq/SRR*.fastq.gz)
do
	echo $file
	id=$(basename $file .fastq.gz | cut -f1 -d"_")
	newid=$(grep $id SraRunTable.txt | awk 'BEGIN{FS="\t"}{gsub(" ", "", $10); print $10}')
	type=$(grep $id SraRunTable.txt | cut -f3)
	cellType=$(grep $id SraRunTable.txt | awk 'BEGIN{FS="\t"}{gsub(" ", "", $12); gsub("/", "", $12); print $12}')
	gsm=$(grep $id SraRunTable.txt | cut -f9)
        outName=$(grep $gsm sampleNames.txt | awk 'BEGIN{FS="\t"}{gsub(" ", "", $2); print $2}')
	mv $file $(echo $file | awk -v id=$id -v newid=$outName '{gsub(id, newid"."id); print}')
done
