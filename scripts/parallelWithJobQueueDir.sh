#!/bin/bash

echo "" > test-output

while [ true ]
do
	files=''
	files=$(ls ./jobqueue)
	echo $files > test-output 
	# TODO give files contents
	# TODO echo content of files
	parallel sh :::: $files 
	# for file in $files
	# do
		# echo $file && rm ./jobqueue/$file || echo "failed to process file $(file)"
	# done
	sleep 5 # seconds
done

# TODO collect file names to supply to parallel

# TODO feed parallel all the files so that it reads and executes them in parallel
