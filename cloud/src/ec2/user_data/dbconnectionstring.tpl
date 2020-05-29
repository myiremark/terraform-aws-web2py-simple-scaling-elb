#! /bin/bash

sed -i "/^uri /c\uri = postgres://${app_db_user}:${app_db_password}@${app_db_address}/${app_db_name}" /home/www-data/web2py/applications/welcome/private/appconfig.ini;

