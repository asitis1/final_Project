#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Hi this is abhiyan Lab 6 $myip</h2><br>How are you?!"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd