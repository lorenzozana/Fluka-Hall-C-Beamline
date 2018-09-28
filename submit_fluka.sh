file="beam_time.txt"
# 3600/5 = 720
hconv=720 
i=0
run_per_conf=20
sub=0
here_pos=`pwd`
while read line ; do
    
    if [ $i -gt 0 ] 
    then
	conf_n=`echo $line | awk '{printf("%s \n",$1)}'`
	conf_n=`echo $conf_n |  sed 's/ /*/g'`
	target=`echo $line | awk '{printf("%s \n",$2)}'`
	target=`echo $target |  sed 's/ /*/g'`
	hours=`echo $line | awk '{printf("%s \n",$3)}'`
	hours=`echo $hours |  sed 's/ /*/g'`
	seconds=`awk -vp=$hours -vq=$hconv 'BEGIN{printf "%6d" ,p * q}'`	
	# seconds divided by 5 (3600/5) since I will consider 5 different time of irradiation followed by 4 of waiting beam
	current=`echo $line | awk '{printf("%s \n",$4)}'`
	current=`echo $current |  sed 's/ /*/g'`
	current=`awk -vp=$current -vq="6.25E12" 'BEGIN{printf "%.2E" ,p * q}'`
	# need to modify the current in particle per second
	energy=`echo $line | awk '{printf("%s \n",$5)}'`
	energy=`echo $energy |  sed 's/ /*/g'`
	energy=`awk -vp=$energy 'BEGIN{printf "%4s",p}'`
	echo "Conf n.="$conf_n "target="$target " seconds="$seconds "current="$current " energy="$energy
	perl -pe "s/.*/IRRPROFI     $seconds.  $current   $seconds.       0.0   $seconds.  $current/ if $. == 1056 ; s/.*/IRRPROFI     $seconds.  $current   $seconds.       0.0   $seconds.  $current/ if $. == 1062 ; s/.*/IRRPROFI     $seconds.       0.0   $seconds.  $current   $seconds.       0.0/ if $. == 1059 ; s/.*/BEAM           -$energy             .142857      0.01      0.01          ELECTRON/ if $. == 6" < hallC_beampipe_${target}.inp >  hallC_beampipe_${target}_${conf_n}.inp
	j=0
	while [ $j -le ${run_per_conf} ] 
	do
	    rn=`perl -e 'my $minimum = 1E8 ; my $range = 9E7 ; my $random_number = int(rand($range)) + $minimum ; print $random_number '`
	    perl -pe "s/.*/RANDOMIZ          1.$rn./ if $. == 9" < hallC_beampipe_${target}_${conf_n}.inp > hallC_beampipe_${target}_${conf_n}_${j}.inp 
	    echo "PROJECT: radcon" > farmrun_radcon_hall${conf_n}_${j}.jsub 
	    echo "TRACK: simulation" >> farmrun_radcon_hall${conf_n}_${j}.jsub
	    echo "JOBNAME: HallC_beampipe"${conf_n} >> farmrun_radcon_hall${conf_n}_${j}.jsub
	    echo "COMMAND: ~/Hall-C/run_fluka_multiple.sh" >> farmrun_radcon_hall${conf_n}_${j}.jsub
	    echo "MEMORY: 2000 MB" >> farmrun_radcon_hall${conf_n}_${j}.jsub                        
	    echo "OS: centos7" >> farmrun_radcon_hall${conf_n}_${j}.jsub                            
	    echo "INPUT_FILES: "${here_pos}"/hallC_beampipe_"${target}"_"${conf_n}"_"${j}".inp" >> farmrun_radcon_hall${conf_n}_${j}.jsub
	    if [ ${sub} -eq "1" ]                                                                               
            then
		echo "Submitting job Conf n." $conf_n " n." $j
		jsub farmrun_radcon_hall${conf_n}_${j}.jsub
	    fi
	    ((j=j+1))
	done
    fi
    ((i=i+1)) 
done < $file 


#    perl -pe "s/.*/\/moller\/ana\/rootfilename sc_attach_flux_${i} / if $. == 1" < run_prex.mac > run_prex_${i}.mac
