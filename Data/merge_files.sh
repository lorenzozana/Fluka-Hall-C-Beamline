#!/bin/bash
#Usage: ./merge_files.sh basename_out bin_number target conf_n
NAME=`echo $1`
BIN=`echo $2`
TARGET=`echo $3`
CONF_N=`echo $4` 
rm ${NAME}_${BIN}.txt
ls -1 *${TARGET}_${CONF_N}_*_fort.${BIN} > ${NAME}_${BIN}.txt
echo >> ${NAME}_${BIN}.txt
echo ${NAME}_${TARGET}_${CONF_N}_${BIN}".bnn" >> ${NAME}_${BIN}.txt
# Create the files with the path to the results
nice ${FLUPRO}/flutil/usbsuw < ${NAME}_${BIN}.txt >$NAME.log
