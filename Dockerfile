ARG TOMCAT_REL="9"
ARG TOMCAT_VERSION="9.0.52"

FROM jupyter/base-notebook:python-3.7.6

USER root

# Install base image dependancies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        openjdk-11-jre \
    && rm -rf /var/lib/apt/lists/*

# Install Apache Tomcat
ARG TOMCAT_REL
ARG TOMCAT_VERSION
RUN wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_REL}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /tmp \
    && mv /tmp/apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat \
    && mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps.dist \
    && mkdir /usr/local/tomcat/webapps \
    && sh -c 'chmod +x /usr/local/tomcat/bin/*.sh'

USER $NB_USER

# CMD ["/usr/local/tomcat/bin/startup.sh", "&&", "jupyter", "notebook", "--ip", "0.0.0.0"]