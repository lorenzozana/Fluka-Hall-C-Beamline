file="beam_time.txt"
# 3600/5 = 720
hconv=720 
i=0
run_per_conf=20
while read line ; do
    
    if [ $i -gt 0 ] 
    then
	conf_n=`echo $line | awk '{printf("%s \n",$1)}'`
	conf_n=`echo $conf_n |  sed 's/ /*/g'`
	target=`echo $line | awk '{printf("%s \n",$2)}'`
	target=`echo $target |  sed 's/ /*/g'`
	hours=`echo $line | awk '{printf("%s \n",$3)}'`
	hours=`echo $hours |  sed 's/ /*/g'`
	seconds=`awk -vp=$hours -vq=$hconv 'BEGIN{printf "%d" ,p * q}'`
	if [ "${#seconds}" -eq "4" ]
	    then
	    seconds=`echo "  " $seconds`
	fi
	# seconds divided by 5 (3600/5) since I will consider 5 different time of irradiation followed by 4 of waiting beam
	current=`echo $line | awk '{printf("%s \n",$4)}'`
	current=`echo $current |  sed 's/ /*/g'`
	current=`awk -vp=$current -vq="6.25E12" 'BEGIN{printf "%.2E" ,p * q}'`
	# need to modify the current in particle per second
	energy=`echo $line | awk '{printf("%s \n",$5)}'`
	energy=`echo $energy |  sed 's/ /*/g'`
	echo "Conf n.="$conf_n "target="$target " seconds="$seconds "current="$current " energy="$energy
#	perl -pe "s/.*/IRRPROFI     604800.   $current   345600.       0.0   604800.   $current/ if $. == 1056" < hallC_beampipe_${target}.inp >  hallC_beampipe_${target}_${conf_n}.inp
	
    fi
    ((i=i+1)) 
done < $file 


#    perl -pe "s/.*/\/moller\/ana\/rootfilename sc_attach_flux_${i} / if $. == 1" < run_prex.mac > run_prex_${i}.mac
