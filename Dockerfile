
# based on https://github.com/tutumcloud/tutum-docker-tomcat/blob/master/7.0/Dockerfile
# and https://github.com/dockerfile/java/blob/master/oracle-java7/Dockerfile

# Pull base image.
FROM dockerfile/ubuntu

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
  apt-get install -y python-setuptools python-dev build-essential && \
  easy_install -U mercurial awscli
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/* && \
#  rm -rf /var/cache/oracle-jdk7-installer
 
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.11
ENV CATALINA_HOME /root/tomcat 

ENV ANT_MINOR_VERSION 1.9.4

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

RUN wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_MINOR_VERSION}-bin.tar.gz && \
    tar zxf apache-ant-*.tar.gz && \
    rm apache-ant-*.tar.gz && \
    mv apache-ant-* ant

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle


# XTF
ENV XTF_DATA /data  # might not need
ENV XTF_HOME /xtf

ADD run.sh /run.sh
ADD init.sh /init.sh
RUN chmod +x /*.sh

EXPOSE 8080
CMD ["/run.sh"]
