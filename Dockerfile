ARG TOMCAT_REL="9"
ARG TOMCAT_VERSION="9.0.52"

FROM jupyter/base-notebook:python-3.7.6

# USER root

# # Install base image dependancies
# RUN apt-get update \
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#         openjdk-11-jre \
#     && rm -rf /var/lib/apt/lists/*

# USER $NB_USER

# # Install Apache Tomcat
# ARG TOMCAT_REL
# ARG TOMCAT_VERSION
# RUN wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_REL}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -P /tmp \
#     && tar -xf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /tmp \
#     && mv /tmp/apache-tomcat-${TOMCAT_VERSION} $HOME/tomcat

# RUN pip install jupyter-server-proxy
# COPY jupyter_notebook_config.py /home/jovyan/.jupyter

# ENTRYPOINT ["/bin/bash"]

# CMD ["/bin/bash"]
# CMD ["/usr/local/tomcat/bin/startup.sh", "&&", "jupyter", "notebook", "--ip", "0.0.0.0"]