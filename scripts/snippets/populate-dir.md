# HOW TO create directory of 30 files with content.

##### populate jobqueue/ with files named 1 through 30.

seq 1 30 | parallel 'touch [dirToPopulate]/{}'

##### populate those 30 files with each file's name. (so file 1 contents = "1", etc...)

seq 1 30 | parallel 'echo {} > [dirToPopulate]/{}'

##### populate those 30 files with COMMAND ECHOING each file's name. (so file 1 contents = "echo 1", etc...)
seq 1 30 | parallel 'echo echo {} > [dirToPopulate]/{}'