sex=female
File1=$(ls peaks/*E13.5*_${sex}.mm9.norandom.bed)
File2=$(ls peaks/*E14.5*_${sex}.mm9.norandom.bed)
File3=$(ls peaks/*E16.5*_${sex}.mm9.norandom.bed)
type1=E13.5
type2=E14.5
type3=E16.5
id=${type1}_${type2}_${type3}_${sex}
rm File1 File2 File3

cat $File1 $File2 $File3 | sort -k1,1 -k2n,2 | bedtools merge -i - > merged.bed
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File1 > File1
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File2 > File2
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File3 > File3
intersectBed -u -F 1 -f 1 -a File1 -b File2 > overlapFile12
intersectBed -u -F 1 -f 1 -a File1 -b File3 > overlapFile13
intersectBed -u -F 1 -f 1 -a File2 -b File3 > overlapFile23

newFile1=$(wc -l overlapFile[12][23] | sort -k1n,1 | head -1 | awk '{print $2}')
newFile2=$(wc -l overlapFile[12][23] | sort -k1n,1 | head -2 | tail -1 | awk '{print $2}')
intersectBed -u -f .5 -F .5 -e -a $newFile1 -b $newFile2 > overlapFile123_${sex}
#intersectBed -u -f .5 -F .5 -e -a overlapFile12 -b overlapFile23 > overlapFile123_${sex}


sh getThreewayPeakVenns.sh File1 File2 overlapFile12 NA $type1 $type2 $id File3 overlapFile13 overlapFile23 $type3 overlapFile123_${sex}
rm overlapFile
#intersectBed -wo -b $File1 -a $File2
wc -l overlapFile12 overlapFile13 overlapFile23 overlapFile123_${sex}
