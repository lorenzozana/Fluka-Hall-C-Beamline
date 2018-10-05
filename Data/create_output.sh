file="beam_time.txt"
i=0
here_pos=`pwd`
while read line ; do
#starting number for getting the minimum of the files number with 1 configuration. Need to be bigger or same as the answer
min_files=100     
    if [ $i -gt 0 ] 
    then
	conf_n=`echo $line | awk '{printf("%s \n",$1)}'`
	conf_n=`echo $conf_n |  sed 's/ /*/g'`
	target=`echo $line | awk '{printf("%s \n",$2)}'`
	target=`echo $target |  sed 's/ /*/g'`
	hours=`echo $line | awk '{printf("%s \n",$3)}'`
	hours=`echo $hours |  sed 's/ /*/g'`
	current=`echo $line | awk '{printf("%s \n",$4)}'`
	current=`echo $current |  sed 's/ /*/g'`
	energy=`echo $line | awk '{printf("%s \n",$5)}'`
	energy=`echo $energy |  sed 's/ /*/g'`
	echo "Conf n.="$conf_n "target="$target " hours="$hours "current="$current " energy="$energy
	./merge_files.sh dose 27 $target $conf_n
	./merge_files.sh activation 64 $target $conf_n
	num_files_at=`ls -1 *${TARGET}_${CONF_N}_*_fort.27 | wc -l `
	if [ "$num_files_at" -lt "$min_files" ]
	then
	    min_files=`echo $num_files_at`
	fi
	
    fi
    ((i=i+1)) 
done < $file 
