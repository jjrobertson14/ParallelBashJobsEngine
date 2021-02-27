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
	
	# TODO echo paths of files that will eventually be executed
		# TODO have arguements list be list of $jobQueuePath/$files[n], I'm not thinking about this right
	parallel -d " " echo ::: "$jobQueuePath/" ::: $(echo -n $files)
	
	sleep 5 # seconds
done

# TODO feed parallel all the files so that it reads and executes them in parallel
