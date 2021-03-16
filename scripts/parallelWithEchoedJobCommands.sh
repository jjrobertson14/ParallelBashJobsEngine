#!/bin/bash

# fields
jobQueuePath="../jobqueue-for-jobs-that-echo-commands"

# DEBUG instrumentation
echo "" > test-output
rm -f ../error/* ../archive/*

# DEBUG traps
# trap "reset_n_test_echo_scripts 30;" SIGTERM SIGINT

# Create directories
mkdir -p ../archive ../error ../output

while [ true ]
do
	files=$(ls $jobQueuePath)
	paths=$(echo -n $files | xargs --no-run-if-empty -I{} -d " " echo "$jobQueuePath/{}")

	# for file in $files
	# do
		# echo $file && rm ./jobqueue/$file || echo "failed to process file $(file)"
	# done

	# echo content of files
	# echo $files >> test-output 
	
	# echo paths of files that will eventually be executed
	# parallel -d " " --no-run-if-empty echo >> test-output ::: $paths

	echo $paths > test-command-output
	# Have parallel process commands sent as output from job scripts 
	# (with another parallel process) 
	# (removing each file that runs successfully)
	echo -n $paths | parallel -j2 -d " " --no-run-if-empty \
					'bash {} || mv {} ../error | parallel -I___ -j6 "bash -c ___ >> test-command-output || mv {} ../error"' 
	
	for path in $paths
	do
		if [ ! -z "$path" ] && [ -f "$path" ]
		then
			mv $path ../archive/
		fi
	done

	sleep 1 # seconds
done

# TODO 