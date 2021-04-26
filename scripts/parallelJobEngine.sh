# TODO [#4] Implement: user should drop txt file containing commands one per line to jobs folder

#!/bin/bash

# Constants
CORE_COUNT=$(getconf _NPROCESSORS_ONLN)

# fields
jobQueuePath="../run-each-line-as-job-jobqueue"
dateStampFmt="+%Y%m%d-%H:%M:%S.%s" # use like `date $dateStampFmt`

# Read args
if [ -z $1 ] # 0 arguments have been passed
then
	simultaneousFilesCount=$(if [ $CORE_COUNT -ge 1 ]; then  echo 2; else echo 1; fi) # 2, if 2 are available
	simultaneousCommandsCount=$CORE_COUNT
elif [ -z $2 ] || [ -n $3 ]  # 1 or 3+ arguments have been passed
then
	echo "provide [simultaneousFilesCount, of cpu cores to process job files with] [simultaneousCommandsCount, of cpu cores to process commands from job files]"
	echo "example: parallel 2 6"
	exit 1
else # 2 arguments passed
	simultaneousFilesCount=$1
	simultaneousCommandsCount=$2
fi

# DEBUG instrumentation
rm -f test-output test-error
# rm -f ../error/* ../archive/* 

# DEBUG traps
# trap "reset_n_test_echo_scripts 30;" SIGTERM SIGINT

# Create directories
mkdir -p ../archive ../error ../output ../input ../run-each-line-as-job-jobqueue

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
	fi
	echo -n $jobFilePaths |xargs -I{} chmod +x {} # set script files to executable

	# [ BEGIN COMMAND STRING COMPONENTS ]
		# cat JOB FILE to send the file content as commands to stdout (to laterrun via parallel)
		# (moving each file that fails to run successfully to error dir with a datetimestamp concatenated to it)
	cGetCommandsFromJobScript='( cat {} || mv {} ../error/$(echo {} |cut -d"/" -f3 |cut -d"." -f1)_$(date +%Y%m%d-%H:%M:%S.%s) )'
    # TODO: modify for runing each line from catted file as job
		# Have parallel process commands sent from JOB FILEs
		# (writing each command echoed by a job script file that fails to run successfully to command-error file, along with filename and datetimestamp)
	cRunJobCommands_A="parallel -I___ --jobs ${simultaneousCommandsCount}"
    # 
    cRunJobCommands_B='"bash -c ___ >>command-output 2>>command-error'
    cRunJobCommands_B_success=' && echo  [INFO] ___ ===== $(echo {} |cut -d"/" -f3 |cut -d"." -f1) ===== $(date +%Y%m%d-%H:%M:%S.%s) >>command-output'
    cRunJobCommands_B_failure=' || echo [ERROR] ___ ===== $(echo {} |cut -d"/" -f3 |cut -d"." -f1) ===== $(date +%Y%m%d-%H:%M:%S.%s) >> command-error"'
	cRunJobCommands="( $cRunJobCommands_A $cRunJobCommands_B $cRunJobCommands_B_success $cRunJobCommands_B_failure )"
	# [ END COMMAND STRING COMPONENTS ]
	
	# [RUN PARALLEL] 
	# Pass content of each JOB FILE containing JOBs to run on each line to a parallel process that runs each JOB
	echo -n $jobFilePaths | parallel --jobs ${simultaneousFilesCount} -d " " --no-run-if-empty \
		"${cGetCommandsFromJobScript} | ${cRunJobCommands}"
	
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