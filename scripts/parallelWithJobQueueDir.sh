#!/bin/bash

# fields
jobQueuePath="../jobqueue"

# DEBUG instrumentation
echo "" > test-output
reset_n_test_echo_scripts() {
    find $jobQueuePath -type f -exec rm {} \;
	echo "KILL SIGNAL RECIVED - resetting $1 test echo scripts"
	seq 1 $1 | parallel "touch $jobQueuePath/{}"
	seq 1 $1 | parallel "echo echo {} > $jobQueuePath/{}"
	exit 0
}


# DEBUG traps
trap "reset_n_test_echo_scripts 30" SIGTERM SIGINT

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

	# feed parallel the paths of the files in the job queue so that it executes them, and then remove each file that ran successfully
	echo $paths | parallel -d " " --no-run-if-empty \
					'sh {} >> test-output && rm {} || echo "failed to process file {}"'

	sleep 2 # seconds
done

# TODO Have parallel process individual job (with another parallel process?) (based on filename?)