#!/usr/bin/env sh

git clone --depth 1 https://github.com/ddm/radapi /opt/radapi
cd /opt/radapi
npm install
mkdir -p /opt/radapi/data/
adduser radapi
chown -R radapi:radapi /opt/radapi/
