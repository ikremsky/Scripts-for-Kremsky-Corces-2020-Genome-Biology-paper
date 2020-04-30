for type in IAPEz-int IAPLTR1_Mm
do
	grep $type /Zulu/isaac/starvation_sperm/mm9_IAPs.bed > temp1
	intersectBed -u -a temp1 -b VM-IAPs_validated.mm9.bed > temp
	intersectBed -v -a temp1 -b VM-IAPs_validated.mm9.bed > temp2

	intersectBed -u -a reprogrammingTFsatIAPs_highestAffinities.bed -b temp > reprogrammingTFsatVMIAPs_highestAffinities.bed
	intersectBed -u -a reprogrammingTFsatIAPs_highestAffinities.bed -b temp2 > reprogrammingTFsatnonVMIAPs_highestAffinities.bed
	R --vanilla --args reprogrammingTFsatnonVMIAPs_highestAffinities.bed reprogrammingTFsatVMIAPs_highestAffinities.bed \
	boxPlots_IAPTFaffinities_reprog_${type}_VM.png < makeBoxPlot_VMIAPs.R


	intersectBed -u -a nonreprogrammingTFsatIAPs_highestAffinities.bed -b temp > nonreprogrammingTFsatVMIAPs_highestAffinities.bed
	intersectBed -u -a nonreprogrammingTFsatIAPs_highestAffinities.bed -b temp2 > nonreprogrammingTFsatnonVMIAPs_highestAffinities.bed
	R --vanilla --args nonreprogrammingTFsatnonVMIAPs_highestAffinities.bed nonreprogrammingTFsatVMIAPs_highestAffinities.bed \
	boxPlots_IAPTFaffinities_nonreprog_${type}_VM.png < makeBoxPlot_VMIAPs.R
done
