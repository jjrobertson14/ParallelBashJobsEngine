#!/bin/bash

jobQueuePath="../jobqueue"

echo "" > output

echo true > jobqueue; tail -F $jobQueuePath | parallel &
echo 'echo a >> output' >> jobqueue
echo 'echo b >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
echo 'echo c >> output' >> jobqueue
