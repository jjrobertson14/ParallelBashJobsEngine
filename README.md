# DESCRIPTION
- Parallel Bash Jobs Engine can run commands in JOB FILES in parallel (using GNU parallel)

- JOB FILES may be one of:
    1. a txt file containing commands one per line
        - In this case, your Job Queue directory to place JOB FILES in is run-each-line-as-job-jobqueue
    2. a script to run as a whole
        - (where each line of stdout that is marked as a command with a prefix of '_-_-_COMMAND' is run in parallel)
        - In this case, your Job Queue directory to place JOB FILES in is run-standard-out-as-jobs-jobqueue

- In order to generate input/sample.txt file... 
    - run openssl command in scripts/snippets/create-random-content-file.md

## For JOB FILE type (1) a txt file containing commands one per line
- First, make sure you have set PBJENGINE_SCRIPT accordingly in /etc/pbjengined.conf (to arallelJobEngine.sh at time of writing)
- The parallel bash jobs engine script that can process these files is scripts/parallelJobEngine.sh
    - run 'bash [path of parallelJobEngine.sh] > [output file path]' to start the engine
    - then copy jobs from ./jobs directory to run-each-line-as-job-jobqueue (if running parallelJobEngine.sh)
        - (See jobs section in DIRECTORY DESCRIPTIONS section below for explanations of jobs)

## For JOB FILE type (2) a script to run as a whole
## (where each line of stdout that is marked as a command with a prefix of '_-_-_COMMAND' is run in parallel)
- First, make sure you have set PBJENGINE_SCRIPT accordingly in /etc/pbjengined.conf (to parallelWithEchoedJobCommands.sh at time of writing)
- The parallel bash jobs engine script that can process these files is scripts/parallelWithEchoedJobCommands.sh
    - run 'bash [path of parallelWithEchoedJobCommands.sh] > [output file path]' to start the engine
        - Sample JOB FILES you may use (that utilize sample.txt file you generated with openssl):
            - succeeds_sedSampleOutputCommands.sh
            - failsEchoedCommand_sedSampleOutputCommands.sh
            - failsScript_sedSampleOutputCommands.sh
        - Script failsEchoedCommand_sedSampleOutputCommands.sh should run succesfully and be moved to archive directory
            - (But if you look in ../command-error output file, you should see that the command 'cat fakie' failed with an error)
            - (Though if you look at ../command-output, you should see messages showing that the sed commands ran succesfully)
        - Script failsScript_sedSampleOutputCommands.sh should fail to run with an error and be moved to error directory
        - Script succeeds_sedSampleOutputCommands.sh should run successfully and be moved to archive directory
            - (Nothing should be written to ../command-error, only ../command-output and output.txt (and maybe test-output file))




# HOW TO USE
## (For JOB FILE type (1) a txt file containing commands one per line)
- First, make sure you have set PBJENGINE_SCRIPT accordingly in /etc/pbjengined.conf (to arallelJobEngine.sh at time of writing)
- run scripts/parallelJobEngine.sh (for example, like `bash scripts/parallelJobEngine.sh > output`)
    - [NOTE] run scripts/parallelJobEngine.sh --help to learn about what arguments you may pass 
        - (they set core count parameters)
    - (ALSO, parallelWithTailDashF.sh may be played around with to help you get a feel for parallel if so desired)
- Then drop job files in run-each-line-as-job-jobqueue/ directory
    - Each job file will be read by cat with a bash process started via parallel 
        - (up to 2 files are read simultaneously by default, utilizing 2 cores, see -j flag of GNU parallel command to learn how that setting is applied)
    - Then, all lines of the JOB FILE are ran as commands 
        - (with simultaneous job commands, the count of simultaneous commands is set based on observed core count on the system)
        - standard output of the commands is appended to ../command-output file
        - standard error of the commands is appended to ../command-error file
            - additionally, an [ERROR] log message is written to the ../command-error file
                - (showing the command that failed with error code, job file it is from, and a datetimestamp)
    - Then, all JOB FILES that were processed are moved to archive/ directory
        - (with datetimestamp appended to filename)

# HOW TO CREATE AND RUN SERVICE DAEMON
- Run initialize_ParallelBashJobsEngine.sh to create the daemon and copy files to /opt/pbjengine
- Interact with daemon by running 'service pbjengined (start|stop|restart|status)'
- The service daemon watches job queue in /opt/pbjengine, and keeps the scripts/parallelJobEngine.sh or scripts/parallelWithEchoedJobCommands.sh file running

- Configuration is stored in /etc/pbjengined.conf.
    - Includes PBJENGINE_SCRIPT property, which determines how the Parallel Bash Jobs Engine processes job files.




# DIRECTORY DESCRIPTIONS
## (committed in git)
## jobs
- Contains example job files that may be dropped in run-standard-out-as-jobs-jobqueue directory
- Script failsEchoedCommand_sedSampleOutputCommands.sh should run succesfully and be moved to archive directory
            - (But if you look in ../command-error output file, you should see that the command 'cat fakie' failed with an error)
            - (Though if you look at ../command-output, you should see messages showing that the sed commands ran succesfully)
        - Script failsScript_sedSampleOutputCommands.sh should fail to run with an error and be moved to error directory
        - Script succeeds_sedSampleOutputCommands.sh should run successfully and be moved to archive directory
            - (Nothing should be written to ../command-error, only ../command-output and output.txt (and maybe test-output file))

## scripts
- snippets dir contains files containing helpful bash snippets 
- parallelJobEngine.sh is the main job engine script

# (DIRECTORIES GENERATED BY PARALLEL ENGINE SCRIPT)
- They appear one directory above where you run the parallelJobEngine.sh or parallelWithEchoedJobCommands.sh file
- If Parallel Bash Jobs Engine is running as a daemon, then they appear in /opt/pbjengine/
## archive
- contains job files that were copied to JOB FILE queue directory that ran succesfully via the job engine
## error
- contains job files that were copied to JOB FILE queue directory that ran unsucessfully via the job engine
## input
- you may put input files in here 
    - (directory is not used at time of writing this)
## output
- you may have your jobs and job commands output to files within this directory 
    - (directory is not used at time of writing this)

# Output files Description
- They appear one directory above where you run the parallelJobEngine.sh or parallelWithEchoedJobCommands.sh file
- If Parallel Bash Jobs Engine is running as a daemon, then they appear in /opt/pbjengine/

## command-error
- contains standard error of job commands that were echoed by job script (lines starting with _-_-_COMMAND- are interpretted as commands)
    - [ERROR] log messages are also written to here
## command-output
- errors of job commands that were echoed by job script (lines starting with _-_-_COMMAND- are interpretted as commands)