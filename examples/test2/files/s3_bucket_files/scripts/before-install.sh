#!/bin/bash
export FOLDER=/opt/app

if [ $(docker ps -f name=^web$ --format '{{ .Names }}') ]
then
  docker stop web
fi

if [ -d $FOLDER ]
then
  rm -rf $FOLDER
fi

mkdir -p $FOLDER
