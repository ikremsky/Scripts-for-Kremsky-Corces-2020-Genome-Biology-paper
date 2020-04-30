#cat peaks/GSM2966930_E9.5.mm9.norandom.bed peaks/GSM2966932_E10.5.mm9.norandom.bed | sort -k1,1 -k2n,2 | bedtools merge -i -> E9.5_10.5_mergedPeaks.bed
#intersectBed -v -a E9.5_10.5_mergedPeaks.bed  -b /media/4TB4/isaac/PGC_DNAseseq/persistentPeaks_maleSpecific > nonPersistentpeaks.bed
#GSM2966946_E14.5_male.mm9.norandom.bed GSM2966950_E16.5_male.mm9.norandom.bed GSM2966942_E13.5_male.mm9.norandom.bed
#intersectBed -v -b peaks/GSM2966950_E16.5_male.mm9.norandom.bed -a peaks/GSM2966946_E14.5_male.mm9.norandom.bed | sort -k4nr,4 > E14.5mnot16.5m.bed
#intersectBed -u -b peaks/GSM2966950_E16.5_male.mm9.norandom.bed -a peaks/GSM2966946_E14.5_male.mm9.norandom.bed | sort -k4nr,4 > E14.5mand16.5m.bed

#awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1}' E14.5mnot16.5m.bed > E14.5mnot16.5m.center.bed
#awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1}' E14.5mand16.5m.bed > E14.5mand16.5m.center.bed
intersectBed -v -a peaks/GSM2966942_E13.5_male.mm9.norandom.bed -b peaks/GSM2966946_E14.5_male.mm9.norandom.bed | sort -k4nr,4 > E13.5not14.5m.bed
awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1}' E13.5not14.5m.bed > E13.5not14.5m.center.bed
intersectBed -u -a peaks/GSM2966942_E13.5_male.mm9.norandom.bed -b persistentPeaks_maleSpecific.bed | sort -k4nr,4 > persistentPeaks_maleSpecific.E13.5.bed
awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1}' persistentPeaks_maleSpecific.E13.5.bed > persistentPeaks_maleSpecific.center.bed

intersectBed -u -a peaks/
