intersectBed -wa -wb -a reprogrammingTFsatIAPs_highestAffinities.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -e IAPEy-int -e IAPEY3-in -e IAPEY4_I-int | cut -f1-5 \
> reprogrammingTFsatyoungIAPs_highestAffinities.bed
intersectBed -wa -wb -a reprogrammingTFsatIAPs_highestAffinities.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -e IAPLTR3-int -e IAPLTR2_Mm | cut -f1-5 > \
reprogrammingTFsatmidIAPs_highestAffinities.bed
intersectBed -wa -wb -a reprogrammingTFsatIAPs_highestAffinities.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -e IAP-d-int -e IAPLTR2a | cut -f1-5 > \
reprogrammingTFsatoldIAPs_highestAffinities.bed
intersectBed -u -a /Zulu/isaac/starvation_sperm/mm9_IAPs.bed -b VM-IAPs_validated.mm9.bed > temp
intersectBed -u -a reprogrammingTFsatIAPs_highestAffinities.bed -b temp > reprogrammingTFsatVMIAPs_highestAffinities.bed
R --vanilla --args reprogrammingTFsatyoungIAPs_highestAffinities.bed reprogrammingTFsatmidIAPs_highestAffinities.bed reprogrammingTFsatoldIAPs_highestAffinities.bed \
boxPlots_IAPTFaffinities_reprog_byAge.png < makeTripleBoxPlots.R


intersectBed -wa -wb -a nonreprogrammingTFsatIAPs_highestAffinities.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -e IAPEy-int -e IAPEY3-in -e IAPEY4_I-int | cut -f1-5 \
> nonreprogrammingTFsatyoungIAPs_highestAffinities.bed

intersectBed -wa -wb -a nonreprogrammingTFsatIAPs_highestAffinities.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -e IAPLTR3-int -e IAPLTR2_Mm | cut -f1-5 > \
nonreprogrammingTFsatmidIAPs_highestAffinities.bed

intersectBed -wa -wb -a nonreprogrammingTFsatIAPs_highestAffinities.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -e IAP-d-int -e IAPLTR2a | cut -f1-5 > \
nonreprogrammingTFsatoldIAPs_highestAffinities.bed
intersectBed -u -a /Zulu/isaac/starvation_sperm/mm9_IAPs.bed -b VM-IAPs_validated.mm9.bed > temp
intersectBed -u -a nonreprogrammingTFsatIAPs_highestAffinities.bed -b temp > nonreprogrammingTFsatVMIAPs_highestAffinities.bed
R --vanilla --args nonreprogrammingTFsatyoungIAPs_highestAffinities.bed nonreprogrammingTFsatmidIAPs_highestAffinities.bed nonreprogrammingTFsatoldIAPs_highestAffinities.bed \
boxPlots_IAPTFaffinities_nonreprog_byAge.png < makeTripleBoxPlots.R

