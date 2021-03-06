# Dockerfile for XTF on AWS Elastic Beanstalk

# based on https://github.com/tutumcloud/tutum-docker-tomcat/blob/master/7.0/Dockerfile
# and https://github.com/dockerfile/java/blob/master/oracle-java7/Dockerfile
# switch to debian
#   http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html

# Pull base image.
FROM debian:wheezy

# Install Java and mecurial
RUN \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -yq --no-install-recommends \
    ca-certificates \
    mercurial \
    oracle-java7-installer \
    oracle-java7-set-default \
    python-dev \
    python-setuptools \
    pwgen \
    wget && \
  easy_install -U \
    awscli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer


# Install Tomcat
ENV TOMCAT_MAJOR_VERSION 7 
ENV TOMCAT_MINOR_VERSION 7.0.56
ENV CATALINA_HOME /tomcat 

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

# Install ant
ENV ANT_MINOR_VERSION 1.9.4

RUN wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_MINOR_VERSION}-bin.tar.gz && \
    tar zxf apache-ant-*.tar.gz && \
    rm apache-ant-*.tar.gz && \
    mv apache-ant-* ant

# XTF
ENV XTF_DATA /xtf/data
ENV XTF_HOME /xtf
ENV OAC_TEMPLATE_BASE /xtf/template-base

COPY run.sh /run.sh
COPY init.sh /init.sh
RUN chmod +x /*.sh

EXPOSE 8080

# set up user to run the app
RUN \
  groupadd -r xtf -g 5555 && \
  useradd -u 5555 -r -g xtf -d /xtf -s \
    /sbin/nologin -c "XTF user" xtf && \
  mkdir /xtf && \
  chown -R xtf:xtf /xtf /tomcat

USER xtf

CMD ["/run.sh"]


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
