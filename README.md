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

! Try out having a token to echo at start of each command to run? 
    - That way the jobs scripts can output whatever is wanted, but still send commands via standard out