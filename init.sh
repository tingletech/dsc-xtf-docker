#!/bin/bash

# initialize XTF app on Docker container

set -ie

# check out XTF
cd /xtf 
hg clone https://bitbucket.org/btingle/dsc-xtf -r dsc-prod-xtf3.0 .
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
mkdir "${OAC_TEMPLATE_BASE}"
cd "${OAC_TEMPLATE_BASE}"
aws s3 cp "${XTF_LAYOUTS}" xtf-includes-layouts-sections.tar.gz
tar zxf xtf-includes-layouts-sections.tar.gz
rm xtf-includes-layouts-sections.tar.gz

# Copyright (c) 2014, Regents of the University of California
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
#- Redistributions of source code must retain the above copyright notice,
#  this list of conditions and the following disclaimer.
#- Redistributions in binary form must reproduce the above copyright
#  notice, this list of conditions and the following disclaimer in the
#  documentation and/or other materials provided with the distribution.
#- Neither the name of the University of California nor the names of its
#  contributors may be used to endorse or promote products derived from
#  this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
