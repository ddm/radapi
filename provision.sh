#!/usr/bin/env bash

git clone --depth 1 https://github.com/ddm/radapi /opt/radapi
cd /opt/radapi
npm install
mkdir -p /opt/node/data/
useradd -ms /bin/bash radapi
chown -R radapi:radapi /opt/radapi/
