#!/bin/bash

jobQueuePath="../jobqueue"

# DEBUG
echo "" > test-output

while [ true ]
do
	files=$(ls $jobQueuePath)
	paths=$(echo $files | xargs -I{} -d " " echo "$jobQueuePath/{}")

	# for file in $files
	# do
		# echo $file && rm ./jobqueue/$file || echo "failed to process file $(file)"
	# done

	# echo content of files
	# echo $files >> test-output 
	
	# echo paths of files that will eventually be executed
	parallel -d " " --no-run-if-empty echo >> test-output ::: $paths

	# TODO feed parallel all the files so that it executes them
	
	sleep 5 # seconds
done

# TODO Have parallel process individual job (with another parallel process?)