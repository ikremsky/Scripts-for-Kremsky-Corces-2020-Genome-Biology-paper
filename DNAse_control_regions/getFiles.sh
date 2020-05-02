mkdir peaks
i=1
for file in $(ls *.txt)
do
	link=$(head -1 $file)
	for pkFile in $(grep narrowPeak $file | awk '{print $1}')
	do
		wget ${link}$pkFile &
	done
	if [ echo $i | awk '{print $1%10}' -eq 0 ]; then
		wait
	fi
	i=$(expr $i + 1)
done
mv *.gz peaks/
