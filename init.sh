#!/bin/bash

# initialize XTF app on Docker container

set -ie

# check out XTF
cd / 
hg clone https://bitbucket.org/btingle/dsc-xtf -r dsc-prod-xtf3.0 xtf
cd /xtf/WEB-INF
/ant/bin/ant

# set up METS support
cd /xtf
hg clone https://bitbucket.org/btingle/mets-support
cd style
ln -s ../mets-support/xslt/view/common

# git rid of default apps and put in a link to XTF
rm -rf /tomcat/webapps/*
ln -s /xtf /tomcat/webapps/xtf

# get a pre-built index from amazon s3
cd /xtf
aws s3 cp "${XTF_INDEX_TAR}" index.tar
tar xf index.tar
rm index.tar

# get layout templates for XTF
cd "${OAC_TEMPLATE_BASE}"
aws s3 cp "${XTF_LAYOUTS}" xtf-includes-layouts-sections.tar.gz
tar zxf xtf-includes-layouts-sections.tar.gz
rm xtf-includes-layouts-sections.tar.gz

