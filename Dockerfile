# Dockerfile for XTF on AWS Elastic Beanstalk

# based on https://github.com/tutumcloud/tutum-docker-tomcat/blob/master/7.0/Dockerfile
# and https://github.com/dockerfile/java/blob/master/oracle-java7/Dockerfile

# Pull base image.
FROM dockerfile/ubuntu

# Install Java and mecurial
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && apt-get install -y \
  build-essential \
  oracle-java7-installer \
  python-dev \
  python-setuptools \
  wget && \
  apt-get install -yq --no-install-recommends \
  ca-certificates \
  pwgen && \
  easy_install -U \
  awscli \
  mercurial && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install Tomcat
ENV TOMCAT_MAJOR_VERSION 7 
ENV TOMCAT_MINOR_VERSION 7.0.56
ENV CATALINA_HOME /root/tomcat 

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

COPY run.sh /run.sh
COPY init.sh /init.sh
RUN chmod +x /*.sh

EXPOSE 8080
CMD ["/run.sh"]
