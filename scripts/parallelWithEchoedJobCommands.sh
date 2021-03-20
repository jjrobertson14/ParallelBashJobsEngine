#!/bin/bash

# fields
jobQueuePath="../jobqueue-for-jobs-that-echo-commands"

# DEBUG instrumentation
# rm -f ../error/* ../archive/* 

# DEBUG traps
# trap "reset_n_test_echo_scripts 30;" SIGTERM SIGINT

# Create directories
mkdir -p ../archive ../error ../output ../input

while [ true ]
do
	files=$(ls $jobQueuePath)
	jobFileNames=$(echo -n $files | xargs --no-run-if-empty -I{} -d " " echo "{}")

	# for file in $files
	# do
		# echo $file && rm ./jobqueue/$file || echo "failed to process file $(file)"
	# done

	echo $jobFileNames > command-output
	# Have parallel process commands sent as output from job scripts 
	# (with another parallel process) 
	# (removing each file that runs successfully)
	# echo -n $jobFileNames | parallel -j2 -d " " --no-run-if-empty \
					# 'bash {} || mv {} ../error | parallel -I___ -j6 "bash -c ___ >> command-output || echo ___ >> command-error"' 
					# 'bash {} || echo {} ../error/$(date +%s%N)_ | parallel -I___ -j6 "bash -c ___ >> command-output || mv {} ../error"' 
	
	for jobfilename in $jobFileNames
	do
		if [ ! -z "$jobQueuePath/$jobfilename" ] && [ -f "$jobQueuePath/$jobfilename" ]
		then
			mv "$jobQueuePath/$jobfilename" ../archive/$(date +%s%N)_$jobfilename
		fi
	done

	sleep 1 # seconds
done