# ParallelBashJobsEngine
An engine to run linux commands in parallel via GNU parallel. 

- The idea is that you will run the engine, copy script files to a "queue" directory, and have them be picked up run as jobs via GNU parallel.
- Each supplied script should be able to be split into multiple jobs that may run on different cores.
