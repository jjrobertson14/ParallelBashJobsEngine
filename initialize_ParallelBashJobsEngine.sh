# Copy init.d script to init.d
cp -a pbjengined_initd /etc/init.d/pbjengined
# Create directories: bin
mkdir -p /opt/pbjengine/bin
# Copy files these files to bin and set permissions: 
cp -a scripts/parallelWithEchoedJobCommands.sh /opt/pbjengine/bin
cp -a scripts/start-pbjengined.sh /opt/pbjengine/bin
chmod u+x /opt/pbjengine/bin/start-pbjengined.sh

# TODO create /etc/pbjengined.conf (or get this directory to be created?... /etc/pbjengined)

# After creating the file run sudo update-rc.d myservice defaults to install your 
# service (here referred as myservice). refer to update-rec.d, Then you can start 
# and stop your service using sudo service myservice start
# 
# [https://askubuntu.com/questions/1261213/how-to-write-an-init-script-that-will-execute-an-existing-start-script-in-ubuntu]
sudo update-rc.d pbjengined defaults
echo "Initialization complete, run 'service pbjengined (start|stop|restart|status)' to interact with Parallel Bash Jobs Engine daemon..."
echo "Then, copy JOB FILES to job queue directory within /opt/pbjengine/"