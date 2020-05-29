#! /bin/bash

curl -O https://raw.githubusercontent.com/web2py/web2py/master/scripts/setup-web2py-nginx-uwsgi-ubuntu.sh;

chmod +x setup-web2py-nginx-uwsgi-ubuntu.sh;

./setup-web2py-nginx-uwsgi-ubuntu.sh --no-password;

echo 'server {
        listen          80;
        server_name     $hostname;

        location ~* ^/(\w+)/static(?:/_[\d]+\.[\d]+\.[\d]+)?/(.*)$ {
            alias /home/www-data/web2py/applications/$1/static/$2;
            expires max;
        }

        location / {
            uwsgi_pass      unix:///tmp/web2py.socket;
            include         uwsgi_params;
            uwsgi_param     UWSGI_SCHEME $scheme;
            uwsgi_param     SERVER_SOFTWARE    nginx/$nginx_version;
        }
}
' >/etc/nginx/sites-available/web2py

