ARG TOMCAT_REL="9"
ARG TOMCAT_VERSION="9.0.52"
ARG GUACAMOLE_VERSION="1.3.0"

FROM jupyter/base-notebook:python-3.7.6

USER root

# Install base image dependancies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        openjdk-11-jre \
        make \
        libpng-dev \
        libjpeg-turbo8-dev \
        libcairo2-dev \
        libtool-bin \
        libossp-uuid-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Apache Guacamole
ARG GUACAMOLE_VERSION
WORKDIR /etc/guacamole
RUN wget "https://apache.mirror.digitalpacific.com.au/guacamole/${GUACAMOLE_VERSION}/source/guacamole-server-1.3.0.tar.gz" -O /etc/guacamole/guacamole-server-${GUACAMOLE_VERSION}.tar.gz \
    && tar xvf /etc/guacamole/guacamole-server-${GUACAMOLE_VERSION}.tar.gz \
    && cd /etc/guacamole/guacamole-server-${GUACAMOLE_VERSION} \
    && ./configure --with-init-dir=/etc/init.d \
    && make \
    && make install \
    && ldconfig \
    && rm -r /etc/guacamole/guacamole-server-${GUACAMOLE_VERSION}*

# Create Guacamole configurations
COPY --chown=root:root user-mapping.xml /etc/guacamole/user-mapping.xml
RUN echo "user-mapping: /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties \
    && touch /etc/guacamole/user-mapping.xml

USER $NB_USER
# Install Apache Tomcat
ARG TOMCAT_REL
ARG TOMCAT_VERSION
RUN wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_REL}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /tmp \
    && mv /tmp/apache-tomcat-${TOMCAT_VERSION} $HOME/tomcat \
    && rm -rf $HOME/tomcat/webapps/* \
    && wget "https://apache.mirror.digitalpacific.com.au/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-1.3.0.war" -O $HOME/tomcat/webapps/ROOT.war

RUN pip install jupyter-server-proxy
COPY jupyter_notebook_config.py /home/jovyan/.jupyter