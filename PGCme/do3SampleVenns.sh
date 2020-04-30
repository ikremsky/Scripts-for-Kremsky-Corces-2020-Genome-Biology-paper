File1=E13.5mBS-Seq_demethResistant.bed
File2=../BSseq_BPAyoonhee/hypoDMRs.bed
File3=/Zulu/isaac/BSseq_BPAYoonhee/IAPs_subset2/All_subset2.insertion.refined.bp.summary.bed
#/media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed

type1=demethResistantCpGs
type2=BPAhypoDMRs
type3=IAPs
id=${type1}_${type2}_${type3}
rm File1 File2 File3

cat $File1 $File2 $File3 | sort -k1,1 -k2n,2 | bedtools merge -i - > merged.bed
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File1 > File1
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File2 > File2
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File3 > File3
intersectBed -u -a File1 -b File2 > overlapFile12
intersectBed -u -a File1 -b File3 > overlapFile13
intersectBed -u -a File2 -b File3 > overlapFile23

newFile1=$(wc -l overlapFile[12][23] | sort -k1n,1 | head -1 | awk '{print $2}')
newFile2=$(wc -l overlapFile[12][23] | sort -k1n,1 | head -2 | tail -1 | awk '{print $2}')
intersectBed -u -f .5 -F .5 -e -a $newFile1 -b $newFile2 > overlapFile123_${sex}
#intersectBed -u -f .5 -F .5 -e -a overlapFile12 -b overlapFile23 > overlapFile123_${sex}


sh getThreewayPeakVenns.sh File1 File2 overlapFile12 NA $type1 $type2 $id File3 overlapFile13 overlapFile23 $type3 overlapFile123_${sex}
rm overlapFile
#intersectBed -wo -b $File1 -a $File2
wc -l overlapFile12 overlapFile13 overlapFile23 overlapFile123_${sex}
