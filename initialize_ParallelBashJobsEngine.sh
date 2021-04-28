# Copy init.d script to init.d
cp -a pbjengined_initd /etc/init.d/pbjengined




# Create directories: bin
mkdir -p /opt/pbjengine/bin
# Copy files these files to bin and set permissions: 
cp -a scripts/parallelJobEngine.sh /opt/pbjengine/bin
cp -a scripts/runParallelJobEngine.sh /opt/pbjengine/bin
cp -a scripts/parallelWithEchoedJobCommands.sh /opt/pbjengine/bin
cp -a scripts/start-pbjengine.sh /opt/pbjengine/bin/pbjengine.sh
chmod u+x /opt/pbjengine/bin/pbjengine.sh
# Create Config File /etc/pbjengined.conf
cp -a pbjengined.conf /etc/pbjengined.conf
# Install parallel if not installed
dpkg-query -W parallel || apt-get -y install parallel




# After creating the file run sudo update-rc.d myservice defaults to install your 
# service (here referred as myservice). refer to update-rec.d, Then you can start 
# and stop your service using sudo service myservice start
# 
# [https://askubuntu.com/questions/1261213/how-to-write-an-init-script-that-will-execute-an-existing-start-script-in-ubuntu]
sudo update-rc.d pbjengined defaults
echo "Initialization complete, run 'service pbjengined (start|stop|restart|status)' to interact with Parallel Bash Jobs Engine daemon..."
echo "Then, copy JOB FILES to job queue directory within /opt/pbjengine/"