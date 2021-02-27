#!/bin/bash

echo "" > output

echo true > jobqueue; tail -F jobqueue | parallel &
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
