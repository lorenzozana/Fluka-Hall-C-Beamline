file="beampipe_design.txt"
i=0
at_al=0
at_304=0
at_347=0
while read line ; do
    
    if [ $i -gt 0 ] 
    then
	start=`echo $line | awk '{printf("%s \n",$1)}'`
	start=`echo $start |  sed 's/ /*/g'`
	length=`echo $line | awk '{printf("%s \n",$7)}'`
	length=`echo $length |  sed 's/ /*/g'`
	oradius=`echo $line | awk '{printf("%s \n",$3)}'`
	oradius=`echo $oradius |  sed 's/ /*/g'`
	iradius=`echo $line | awk '{printf("%s \n",$5)}'`
	iradius=`echo $iradius |  sed 's/ /*/g'`
	material=`echo $line | awk '{printf("%s \n",$8)}'`
	material=`echo $material |  sed 's/ /*/g'`
	num=`printf "%02d" $i`
	oname=`echo "opipe"$num`
	iname=`echo "ipipe"$num`
	if [ $i -eq 1 ]
	then
	    echo "RCC "$oname"    0.0 0.0 "$start" 0.0 0.0 "$length" "$oradius > bodies.txt
	    echo "RCC "$iname"    0.0 0.0 "$start" 0.0 0.0 "$length" "$iradius >>  bodies.txt
	    echo "BEAMVAC      5 +"$iname > region2.txt
	else
	    echo "RCC "$oname"    0.0 0.0 "$start" 0.0 0.0 "$length" "$oradius >>  bodies.txt
	    echo "RCC "$iname"    0.0 0.0 "$start" 0.0 0.0 "$length" "$iradius >>  bodies.txt
            echo "               | +"$iname >> region2.txt
	fi
	if [ "$material" == "6061-T6Alum" ]
	then 
	    if [ $at_al = 0 ]
	    then 
		echo "BEAM_AL      5 +"$oname" -"$iname > region_al.txt
	    else
		echo "               | +"$oname" -"$iname >> region_al.txt
	    fi
	    ((at_al=at_al+1))
	fi
	if [ "$material" == "304SS" ]
	then 
	    if [ $at_304 = 0 ]
	    then 
		echo "BEAM304SS    5 +"$oname" -"$iname > region_304ss.txt
	    else
		echo "               | +"$oname" -"$iname >> region_304ss.txt
	    fi
	    ((at_304=at_304+1))
	fi
	if [ "$material" == "347SS" ]
	then 
	    if [ $at_347 = 0 ]
	    then 
		echo "BEAM347SS    5 +"$oname" -"$iname > region_347ss.txt
	    else
		echo "               | +"$oname" -"$iname >> region_347ss.txt
	    fi
	    ((at_347=at_347+1))
	fi

    fi
    ((i=i+1)) 
done < $file 


#    perl -pe "s/.*/\/moller\/ana\/rootfilename sc_attach_flux_${i} / if $. == 1" < run_prex.mac > run_prex_${i}.mac
