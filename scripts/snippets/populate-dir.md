# HOW TO create directory of 30 files with content.

##### populate jobqueue/ with files named 1 through 30.

seq 1 30 | parallel 'touch [dirToPopulate]/{}'

##### populate those 30 files with each file's name. (so file 1 contents = "1", etc...)

seq 1 30 | parallel 'echo {} > [dirToPopulate]/{}'

##### populate those 30 files with COMMAND ECHOING each file's name. (so file 1 contents = "echo 1", etc...)
seq 1 30 | parallel 'echo echo {} > [dirToPopulate]/{}'


##### populate n files with name being [the number of the file], content being "echo [the number of the file]"
reset_n_test_echo_scripts() {
    find $jobQueuePath -type f -exec rm {} \;
	echo "KILL SIGNAL RECIVED - resetting $1 test echo scripts"
	seq 1 $1 | parallel "touch $jobQueuePath/{}"
	seq 1 $1 | parallel "echo echo {} > $jobQueuePath/{}"
	exit 0
}
