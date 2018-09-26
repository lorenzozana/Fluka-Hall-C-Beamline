file="beam_time.txt"
i=0
while read line ; do
    
    if [ $i -gt 0 ] 
    then
	target=`echo $line | awk '{printf("%s \n",$2)}'`
	target=`echo $target |  sed 's/ /*/g'`
	hours=`echo $line | awk '{printf("%s \n",$3)}'`
	hours=`echo $hours |  sed 's/ /*/g'`
	((seconds=hours*720))
	# seconds divided by 5 (3600/5) since I will consider 5 different time of irradiation followed by 4 of waiting beam
	current=`echo $line | awk '{printf("%s \n",$4)}'`
	current=`echo $current |  sed 's/ /*/g'`
	# need to modify the current in particle per second
	energy=`echo $line | awk '{printf("%s \n",$5)}'`
	energy=`echo $energy |  sed 's/ /*/g'`
    fi
    ((i=i+1)) 
done < $file 


#    perl -pe "s/.*/\/moller\/ana\/rootfilename sc_attach_flux_${i} / if $. == 1" < run_prex.mac > run_prex_${i}.mac
