# TODO get pbjengine installed in /opt/pbjengine 
    # Create directories: bin
    # Copy files these files to it: 
        # cp -a pbjengined_initd /etc/init.d/pbjengined
        # cp -a scripts/parallelWithEchoedJobCommands.sh /opt/pbjengine/bin
        # cp -a scripts/start-pbjengined.sh /opt/pbjengine/bin

# TODO get this directory to be created?... /etc/pbjengined
# TODO create /etc/pbjengined.conf


cp pbjengined_initd /etc/init.d/pbjengined
# After creating the file run sudo update-rc.d myservice defaults to install your 
# service (here referred as myservice). refer to update-rec.d, Then you can start 
# and stop your service using sudo service myservice start
# 
# [https://askubuntu.com/questions/1261213/how-to-write-an-init-script-that-will-execute-an-existing-start-script-in-ubuntu]
# TODO update 'myservice' text here
sudo update-rc.d myservice defaults
