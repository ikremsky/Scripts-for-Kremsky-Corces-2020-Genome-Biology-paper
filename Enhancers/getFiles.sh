link=http://hgdownload.soe.ucsc.edu/goldenPath/mm9/encodeDCC/wgEncodeLicrHistone/
mkdir bed
for file in $(grep -i peak Files.txt | awk '{print $1}')
do
	wget ${link}$file
done
mv *gz bed/
