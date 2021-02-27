#!/bin/bash

jobQueuePath="../jobqueue"

# DEBUG
echo "" > test-output

while [ true ]
do
	files=''
	files=$(ls $jobQueuePath)

	# for file in $files
	# do
		# echo $file && rm ./jobqueue/$file || echo "failed to process file $(file)"
	# done

	# echo content of files
	# echo $files >> test-output 
	
	parallel -d " " echo ::: $files 
	
	sleep 5 # seconds
done

# TODO collect file names to supply to parallel

# TODO feed parallel all the files so that it reads and executes them in parallel
