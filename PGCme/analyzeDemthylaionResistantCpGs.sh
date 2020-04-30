meFile=/Zulu/isaac/PGCme/bed/E13.5mBS-Seq_meth.bed
#/media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed

awk '$5+$6 > 5 && $4 > .4' /Zulu/isaac/PGCme/bed/E13.5mBS-Seq_meth.bed > E13.5mBS-Seq_demethResistant.bed
intersectBed -u -a E13.5mBS-Seq_demethResistant.bed -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > E13.5mBS-Seq_demethResistant.atIAPs.bed
intersectBed -v -a E13.5mBS-Seq_demethResistant.bed -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > E13.5mBS-Seq_demethResistant.notatIAPs.bed
#awk 'BEGIN{OFS="\t"}{if($2-2000 < 1) start=1; else start=$2-2000; print $1,start,$3+2000,$4,$5,$6}' /Zulu/isaac/starvation_sperm/mm9_repeats.bed > mm9_repeats_plus2kb.bed
#intersectBed -u -a E13.5mBS-Seq_demethResistant.bed -b mm9_repeats_plus2kb.bed > E13.5mBS-Seq_demethResistant_atRepeats.bed
#intersectBed -v -a E13.5mBS-Seq_demethResistant.bed -b mm9_repeats_plus2kb.bed > E13.5mBS-Seq_demethResistant_notatRepeats.bed
