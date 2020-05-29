#! /bin/bash

systemctl restart emperor.uwsgi.service;
service nginx restart;

