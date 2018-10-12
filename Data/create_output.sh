file="beam_time.txt"
i=0
# Create an output for each configuration
min_files=100 
#starting number for getting the minimum of the files number with 1 configuration. Need to be bigger or same as the answer    
while read line ; do
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
	num_files_at=`ls -1 *${target}_${conf_n}_*_fort.27 | wc -l `
	echo "Files with this config=" $num_files_at
	if [ "$num_files_at" -lt "$min_files" ]
	then
	    min_files=`echo $num_files_at`
	fi	
    fi
    ((i=i+1)) 
done < $file 

echo "Minimum files for configuration ="$min_files



# create accumulated list of files with min_files for each target and create the output
# The Dose-eq is expressed as accumulated dose per single target in pSV. The accumulated dose will be the average dose for all the configurations with the same number input files per configuration: Since the activation will be the sum of each configuration, the final answer will be the average multiplied by the number of configuraions.
# the dose in RAD and the 1MeV equivalent is expressed in amount/electron. One will need correct a sample of events with the correct exposure so that the number of files in the sample is proportional to the (hours x current) for each configuration  
i=0
while read line ; do    
    if [ $i -gt 0 ]
    then
	conf_n=`echo $line | awk '{printf("%s \n",$1)}'`
	conf_n=`echo $conf_n |  sed 's/ /*/g'`
	target=`echo $line | awk '{printf("%s \n",$2)}'`
	target=`echo $target |  sed 's/ /*/g'`
	if [ $i -eq 1 ]
	then
	    ls -1 *${target}_${conf_n}_*_fort.27 | sed -n 1,${min_files}p > accumulated_dose_27.txt
	    ls -1 *${target}_${conf_n}_*_fort.64 | sed -n 1,${min_files}p > accumulated_activation_64.txt
	else 
	    ls -1 *${target}_${conf_n}_*_fort.27 | sed -n 1,${min_files}p >> accumulated_dose_27.txt
	    ls -1 *${target}_${conf_n}_*_fort.64 | sed -n 1,${min_files}p >> accumulated_activation_64.txt
	fi
    fi
    ((i=i+1)) 
done < $file 
echo  >> accumulated_dose_27.txt
echo  >> accumulated_activation_64.txt
echo "accumulated_dose_27.bnn" >> accumulated_dose_27.txt
echo "accumulated_activation_64.bnn" >> accumulated_activation_64.txt
nice ${FLUPRO}/flutil/usbsuw <  accumulated_dose_27.txt > accumulated_dose_27.log
nice ${FLUPRO}/flutil/usbsuw <  accumulated_activation_64.txt > accumulated_activation_64.log
