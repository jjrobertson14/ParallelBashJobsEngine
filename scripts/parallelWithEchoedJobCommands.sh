#!/bin/bash

# fields
jobQueuePath="../jobqueue-for-jobs-that-echo-commands"
dateStampFmt="+%Y%m%d-%H:%M:%S.%s" # use like `date $dateStampFmt`
# TODO add param for optimal job/core counts for parallel calls

# DEBUG instrumentation
rm -f test-output test-error
# rm -f ../error/* ../archive/* 

# DEBUG traps
# trap "reset_n_test_echo_scripts 30;" SIGTERM SIGINT

# Create directories
mkdir -p ../archive ../error ../output ../input ../jobqueue ../jobqueue-for-jobs-that-echo-commands

while [ true ]
do
	# Set variables, looking for job scripts to run
	jobFileNames=$(ls $jobQueuePath) \
					|| echo "failed to create var jobFileName" >> test-error
	jobFilePaths=$(echo -n $jobFileNames | xargs --no-run-if-empty -I{} -d " " echo "$jobQueuePath/{}") \
					|| echo "failed to create var jobFilePaths" >> test-error
	if [ -z $jobFileNames ] || [ -z $jobFilePaths ]
	then
		sleep 1 # seconds
		continue
	else
		echo $jobFileNames >> test-output
		echo $jobFilePaths >> test-output
	fi
	echo -n $jobFilePaths |xargs -I{} chmod +x {}

	# [ BEGIN COMMAND STRING COMPONENTS ]
		# Run job script and take output as commands to run via parallel
		# (moving each file fails to run successfully to error dir)
	cGetCommandsFromJobScript='( bash {} || mv {} ../error/$(echo {} |cut -d"/" -f3 |cut -d"." -f1)_$(date +%Y%m%d-%H:%M:%S.%s) )'
		# In order to allow only specified output of job scripts to be ran as command, 
			# have token "_-_-_COMMAND-" be at start of output strings client wants to run as commands
		# (To do this, grep to select text after token "_-_-_COMMAND-" if it appears at start of piped in string)
	cGrepActualCommandsByToken='( grep -oP "(?<=^_-_-_COMMAND-).*" )'
		# Have parallel process commands sent as output from job scripts 
		# (writing each command echoed by a job script file that fails to run successfully to command-error file)
	cRunJobCommands='( parallel -I___ -j6 "bash -c ___ >>command-output 2>>command-error || echo [ERROR] ___ ===== $(echo {} |cut -d"/" -f3 |cut -d"." -f1) ===== $(date +%Y%m%d-%H:%M:%S.%s) >> command-error" )'
	# [ END COMMAND STRING COMPONENTS ]
	
	# [RUN PARALLEL] 
	# Pass each job to parallel process that runs subcommands
	echo -n $jobFilePaths | parallel -j2 -d " " --no-run-if-empty \
		"${cGetCommandsFromJobScript} | ${cGrepActualCommandsByToken} | ${cRunJobCommands}"
	
	# [ARCHIVE]
	for jobfilename in $jobFileNames
	do
		# Move each file that ran successfully (i.e. was not moved to error directory) to archive dir
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