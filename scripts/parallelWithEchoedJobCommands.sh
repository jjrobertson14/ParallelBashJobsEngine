#!/bin/bash

# fields
jobQueuePath="../jobqueue-for-jobs-that-echo-commands"

# DEBUG instrumentation
rm -f test-output
# rm -f ../error/* ../archive/* 

# DEBUG traps
# trap "reset_n_test_echo_scripts 30;" SIGTERM SIGINT

# Create directories
mkdir -p ../archive ../error ../output ../input

while [ true ]
do
	jobFileNames=$(ls $jobQueuePath) \
					|| echo "failed to create var jobFileName" >> test-output
	jobFilePaths=$(echo -n $jobFileNames | xargs --no-run-if-empty -I{} -d " " echo "$jobQueuePath/{}") \
					|| echo "failed to create var jobFilePaths" >> test-output
	if [ -z $jobFileNames ] || [ -z $jobFilePaths ]
	then
		continue
	else
		echo $jobFileNames >> test-output
		echo $jobFilePaths >> test-output
	fi

	# Have parallel process commands sent as output from job scripts 
	# (with another parallel process) 
	# (moving each file that runs successfully to archive dir)
		# (moving each file fails to run successfully to error dir)
		# (writing each command echoed by a job script file that fails to run successfully to command-error file)
	echo -n $jobFilePaths | parallel -j2 -d " " --no-run-if-empty \
		'bash {} || echo {} ../error/$(date +%s%N) | parallel -I___ -j6 "bash -c ___ >> command-output || echo ___ >> ../error/command-error"'
		# 'bash {} || echo {} ../error/$(date +%s%N)_ | parallel -I___ -j6 "bash -c ___ >> command-output || mv {} ../error"' 
	
	# for jobfilename in $jobFileNames
	# do
	# 	if [ ! -z "$jobQueuePath/$jobfilename" ] && [ -f "$jobQueuePath/$jobfilename" ]
	# 	then
	# 		mv "$jobQueuePath/$jobfilename" ../archive/$(date +%s%N)_$jobfilename
	# 	fi
	# done

	sleep 1 # seconds
done