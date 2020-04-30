!na
#awk '{sub(":", "\t"); sub("-", "\t"); print}' VM-IAPs_validated.mm10.txt > VM-IAPs_validated.mm10.bed
file=VM-IAPs_validated.mm10.bed
#/programs/liftOver $file /mnt/isaachd/methylationCellData/mm10ToMm9.over.chain $(echo $file | awk '{sub("mm10", "mm9"); print}') $(echo $file | awk '{sub("mm10", "mm9"); print}').unmapped
