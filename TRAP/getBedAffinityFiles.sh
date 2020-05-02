cd affinities
file=E14.5m_Summits_TEPIC_06_11_19_17_35_44_404916199_Affinity.txt
i=2
for TF in $(head -1 $file)
do
	echo $TF
	i=$(expr $i + 1)
done
