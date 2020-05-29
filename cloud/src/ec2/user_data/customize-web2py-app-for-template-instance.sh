#! /bin/bash

sed -i "/^migrate /c\migrate = false" /home/www-data/web2py/applications/welcome/private/appconfig.ini;
sed -i "/^pool_size /c\pool_size = 100" /home/www-data/web2py/applications/welcome/private/appconfig.ini;

