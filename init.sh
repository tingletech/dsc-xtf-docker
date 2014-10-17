#!/bin/bash

# initialize XTF app on Docker container

set -ie

# check out XTF
cd / 
hg clone https://bitbucket.org/btingle/dsc-xtf -r dsc-prod-xtf3.0 xtf
cd /xtf/WEB-INF
/root/ant/bin/ant

# git rid of default apps and put in a link to XTF
rm -rf /root/tomcat/webapps/*
ln -s /xtf /root/tomcat/webapps/xtf

# get a pre-built index from amazon s3
cd /xtf
aws s3 cp "${XTF_INDEX_TAR}" index.tar
tar xf index.tar
