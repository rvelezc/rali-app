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


Install Procedure:

-Make sure to decompress the package in folder /rali
-Go to the install folder, from now on all the steps are asuming the current path is the install folder:
    cd /rali/rali-app/install

-Install Apache config
    cd apache
    a2dissite default
    cp -f rali_marketing /etc/apache2/sites-available/default
    a2ensite default
    service apache2 reload

-Create the database (Inside model.sql need to assign a new password)
    cd ../database
    mysql -uroot -p'yourpassword' < model.sql
    mysql -uroot -p'yourpassword' --local-infile rali_marketing < setup.sql

-Install Daemons
    cd ../daemons
    rm -f /etc/init/rali_*.conf
    cp rali_*.conf /etc/init

-Install Daemons as services
    cd ../daemons
    rm -f /etc/init.d/rali_calendar
    cp rali_calendar /etc/init.d/
    rm -f /etc/init.d/rali_queue
    cp rali_queue /etc/init.d/
    
-Start services
    service rali_calendar start
    service rali_queue start
    
-Install Log daemon
    cd ../logconf
    rm -f /etc/logrotate.d/rali
    cp rali /etc/logrotate.d/.



