# ParallelBashJobsEngine
An engine to run linux commands in parallel via GNU parallel. 

- The idea is that you will run the engine, copy script files to a "queue" directory, and have them be picked up run as jobs via GNU parallel.
- Each supplied script should be able to be split into multiple jobs that may run on different cores.


- 2021-03-10 Now have sedSample.sh script to test with, it takes a few seconds for each sed in the script to run
    - So, given this, I want to run sed in multiple jobs via parallel by submitting one file to the jobqueue
        - Perhaps have sedSample.sh output commands to be run through parallel? 
            - Have user submit jobs that output commands if they want to use that functionality
                - Got this working (2021-03-11)
            - And in this case file name could include information about how to use parallel
                - ! Try this?

- [ DONE ] [archive and error folders] 

- [ DONE ] [handle errors] of individual commands echoed by job files

- [ DONE ] [ Add timestamps to error/archive files and command-error ]
    - [ DONE ] get outputing commands that are echoed from command script into command-error (along with timestamp and error message itself)


    ! fix up writes to command-error to show error message too, and separate all the components

- ! [ lil interpreter to interpret command separate from other output ] Try out having a token to echo at start of each command to run? 
    - That way the jobs scripts can output whatever is wanted, but still send commands via standard out
        - (could use tee to send all output of job script somewhere to preserve non-command output of the script)

- ! [single job script to execute & command echoing scripts] 
    - ! Copy parallelWithEchoedJobCommands.sh to parallelBashJobsEngine.sh
    - ! Modify to Allow engine to accept both scripts that user desires to run and scripts that echo out commands to be run





! GOOD TO SHOW IT OFF









# Would be Cool To Have
- ! (cool to have) [ expand lil interpreter ] Alow it to accept more tokens