#!/bin/bash

docker run --rm -it -d -p 80:80 --name web -v /opt/app:/usr/share/nginx/html nginx:alpine
