# Rali Marketing App

Rali Marketing App is a tool designed to help users in their social marketing strategies.


# To do
-Get content
-Add users_id foreign key in all the tables
-Add functionality to calendar
-Create Webservices for Calendar, profiles and accounts
-Finish authentication Validation email and all that
-Finish Calendar styling (Completed)
-Add Wizzard for new events on the calendar



Server Procedure

As root, or using sudo run the following steps to configure the system.

Upgrade before anything:
apt-get update && apt-get upgrade

install ssh:
apt-get install openssh-server
edit /etc/ssh/sshd_config
change PermitRootLogin to allow root access with:
PermitRootLogin yes
/etc/init.d/ssh restart


install vim:
apt-get install vim

Install Apache 2
apt-get install apache2

Install MySQL
apt-get install mysql-server

Install PHP
apt-get install php5 php-pear
apt-get install php5-curl
apt-get install sendmail

Install and Configure the app
apt-get install git-core
mkdir -p /rali; cd /rali
git clone https://github.com/rvelezc/rali-app
git config --global alias.add-commit '!git add -A && git commit'
cd rali-app
git remote set-url origin git@github.com:rvelezc/rali-app.git

Install Procedure:

-Make sure the the package is in folder /rali
-Go to the install folder, from now on all the steps are asuming the current path is the install folder:
    cd /rali/rali-app/install

-Install Apache config
    cd apache
    cp -f rali_marketing.conf /etc/apache2/sites-available/rali_marketing.conf
    a2ensite rali_marketing.conf
    service apache2 reload

-Run Installer
   ./install.sh
    
-Start services
    service rali_calendar start
    service rali_queue start



