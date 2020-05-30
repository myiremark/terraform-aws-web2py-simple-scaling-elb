#! /bin/bash

sudo apt-get -y install python-psycopg2;

routes_content="
routes_in = (
    ('/date_time', '/welcome/default/date_time'),
    ('/date_time_only', '/welcome/default/date_time_only'),
    ('/latest_date_time', '/welcome/default/latest_date_time')
)
routes_out = (
    ('/welcome/default/date_time', '/date_time'),
    ('/welcome/default/date_time_only', '/date_time_only'),
    ('/welcome/default/latest_date_time', '/latest_date_time')
)
"

model_content="
# -*- coding: utf-8 -*-

from gluon.contrib.appconfig import AppConfig

configuration = AppConfig()

db = DAL(configuration.get('db.uri'),
         pool_size=configuration.get('db.pool_size'),
         migrate_enabled=configuration.get('db.migrate'),
         check_reserved=['all'])

session.forget(response)

db.define_table('dates_and_times',
    Field('date_and_time','json')
)
"

controller_content="
# -*- coding: utf-8 -*-

def date_time_only():
    content = {'date':request.utcnow.date(),'time':request.utcnow.time()}
    return response.json(content)

def date_time():
    content = {'date':request.utcnow.date(),'time':request.utcnow.time()}
    db.dates_and_times.insert(date_and_time=content)
    return response.json(content)

def latest_date_time():
    table = db.dates_and_times
    return response.json(db(table.id>0).select(orderby=~table.id,limitby=(0,1)).first().date_and_time)
"

echo "$controller_content" > /home/www-data/web2py/applications/welcome/controllers/default.py

echo "$model_content" > /home/www-data/web2py/applications/welcome/models/db.py

echo "$routes_content" > /home/www-data/web2py/routes.py

rm /home/www-data/web2py/applications/welcome/models/menu.py
