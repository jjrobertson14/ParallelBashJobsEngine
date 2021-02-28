#!/bin/bash

# fields
jobQueuePath="../jobqueue"

# DEBUG instrumentation
echo "" > test-output
reset_n_test_echo_scripts() {
    ls $jobQueuePath | parallel --no-run-if-empty -m -d " " -I{} echo "$jobQueuePath/{}"
	echo "INFO - resetting test echo scripts"
	seq 1 $1 | parallel "touch $jobQueuePath/{} ; chmod +x $jobQueuePath/{} ;"
	seq 1 $1 | parallel "echo echo {} > $jobQueuePath/{}"
	exit 0;
}


# DEBUG traps
trap "reset_n_test_echo_scripts 30;" SIGTERM SIGINT

# functions
reset_n_test_echo_scripts_no_exit() {
    ls $jobQueuePath | parallel --no-run-if-empty -m -d " " -I{} echo "$jobQueuePath/{}"
	echo "INFO - resetting test echo scripts"
	seq 1 $1 | parallel "touch $jobQueuePath/{} ; chmod +x $jobQueuePath/{} ;"
	seq 1 $1 | parallel "echo echo {} > $jobQueuePath/{}"
}


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
	echo $paths
	# TODO fix bug where file 9 cannot be executed (it's the last file processed) 'bash: ../jobqueue/9 : No such file or directory'
	echo $paths | parallel -j1 -d " " --no-run-if-empty \
					'bash {} >> test-output && rm {} && echo processed {} || echo "failed to process file {}"'

	sleep 20 # seconds
	reset_n_test_echo_scripts_no_exit 30
done

# TODO Have parallel process individual job (with another parallel process?) (based on filename?)