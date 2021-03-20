#!/bin/bash

# fields
jobQueuePath="../jobqueue-for-jobs-that-echo-commands"
dateStampFmt="+%Y%m%d-%H:%M:%S.%s" # use like `date $dateStampFmt`

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

	echo -n $jobFilePaths |xargs -I{} chmod +x {}

	# Have parallel process commands sent as output from job scripts 
	# (with another parallel process) 
	# (moving each file that runs successfully to archive dir)
		# (moving each file fails to run successfully to error dir)
		# (writing each command echoed by a job script file that fails to run successfully to command-error file)
	echo -n $jobFilePaths | parallel -j2 -d " " --no-run-if-empty \
		'bash {} || mv {} ../error/$(echo {} |cut -d"/" -f3 |cut -d"." -f1)_$(date +%Y%m%d-%H:%M:%S.%s) | parallel -I___ -j6 "bash -c ___ >> command-output || echo $(echo {} |cut -d"/" -f3 |cut -d"." -f1)_$(date +%Y%m%d-%H:%M:%S.%s) ___ >> ../error/command-error"'
		# 'bash {} || echo {} ../error/$(date +%s%N)_ | parallel -I___ -j6 "bash -c ___ >> command-output || mv {} ../error"' 
	
	for jobfilename in $jobFileNames
	do
		if [ ! -z "$jobQueuePath/$jobfilename" ] && [ -f "$jobQueuePath/$jobfilename" ]
		then
			dateTimestamp=$(date +%Y%m%d-%H:%M:%S.%s)
			archiveFilePath="../archive/${jobfilename}_${dateTimestamp}"
			mv "$jobQueuePath/$jobfilename" "$archiveFilePath"
			chmod 664 "$archiveFilePath"
		fi
	done

	sleep 1 # seconds
done