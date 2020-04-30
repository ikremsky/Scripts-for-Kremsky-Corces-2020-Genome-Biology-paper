cd E14.5m_motifs
head -1 summary.txt | cut -f1,2,5 | awk 'BEGIN{OFS="\t"}{print $0,"fpkm_E16.5m"}' > allExpressedAndSignificantTFs_E14.5m.txt
awk '$NF < .001 && $3 > $4' summary.txt | cut -f1,2,5 > temp
awk '$NF > 1' ../cuffdiff/final/E16.5m.genes.fpkm | cut -f5,7 > tempids
#cut -f1 /media/4TB4/isaac/PGCme/countTable_E14.5m > tempids
join -i temp tempids | awk '{gsub(" ", "\t"); print}' >> allExpressedAndSignificantTFs_E14.5m.txt
R --vanilla < ../roundCol3.R
cat allExpressedAndSignificantTFs_E14.5m.txt | awk '$2 >= 100' | awk '{print toupper($1)}' | uniq | wc -l
