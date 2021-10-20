ARG GO_VERSION="1.14.12"
ARG SINGULARITY_VERSION="3.8.2"
ARG TOMCAT_REL="9"
ARG TOMCAT_VERSION="9.0.52"
ARG GUACAMOLE_VERSION="1.3.0"

FROM jupyter/base-notebook:python-3.7.6

USER root

# Install base image dependancies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        locales \
        sudo \
        wget \
        ca-certificates \
        make \
        gcc \
        g++ \
        openjdk-11-jre \
        libpng-dev \
        libjpeg-turbo8-dev \
        libcairo2-dev \
        libtool-bin \
        libossp-uuid-dev \
        libwebp-dev \
        lxde \
        openssh-server \
        libpango1.0-dev \
        libssh2-1-dev \
        libssl-dev \
        openssh-server \
        libvncserver-dev \
        libxt6 \
        xauth \
        xorg \
        freerdp2-dev \
        xrdp \
        xauth \
        xorg \
        xorgxrdp \
        tigervnc-standalone-server \
        tigervnc-common \
        lxterminal \
        lxrandr \
        curl \
        gpg \
        software-properties-common \
        dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

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
COPY --chown=root:root config/user-mapping.xml /etc/guacamole/user-mapping.xml
RUN echo "user-mapping: /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties \
    && touch /etc/guacamole/user-mapping.xml

# Add Visual Studio code and nextcloud client
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vs-code.list \
    && add-apt-repository ppa:nextcloud-devs/client

# Add CVMFS
RUN wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb \
    && dpkg -i cvmfs-release-latest_all.deb \
    && rm cvmfs-release-latest_all.deb

# Install basic tools
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        cryptsetup \
        squashfs-tools \
        lua-bit32 \
        lua-filesystem \
        lua-json \
        lua-lpeg \
        lua-posix \
        lua-term \
        lua5.2 \
        lmod \
        git \
        aria2 \
        code \
        emacs \
        gedit \
        htop \
        imagemagick \
        less \
        nano \
        openssh-client \
        python3-pip \
        rsync \
        screen \
        tree \
        vim \
        gcc \
        python3-dev \
        graphviz \
        libzstd1 \
        libgfortran5 \
        zlib1g-dev \
        zip \
        unzip \
        nextcloud-client \
        iputils-ping \
        sshfs \
        build-essential \
        uuid-dev \
        libgpgme-dev \
        squashfs-tools \
        libseccomp-dev \
        wget \
        pkg-config \
        cryptsetup-bin\
        lsb-release \
        cvmfs \
        rclone \
        davfs2 \
        owncloud-client \
        firefox \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list.d/vs-code.list

# Configure CVMFS
RUN mkdir -p /etc/cvmfs/keys/ardc.edu.au/ \
    && echo "-----BEGIN PUBLIC KEY-----" | sudo tee /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwUPEmxDp217SAtZxaBep" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "Bi2TQcLoh5AJ//HSIz68ypjOGFjwExGlHb95Frhu1SpcH5OASbV+jJ60oEBLi3sD" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "qA6rGYt9kVi90lWvEjQnhBkPb0uWcp1gNqQAUocybCzHvoiG3fUzAe259CrK09qR" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "pX8sZhgK3eHlfx4ycyMiIQeg66AHlgVCJ2fKa6fl1vnh6adJEPULmn6vZnevvUke" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "I6U1VcYTKm5dPMrOlY/fGimKlyWvivzVv1laa5TAR2Dt4CfdQncOz+rkXmWjLjkD" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "87WMiTgtKybsmMLb2yCGSgLSArlSWhbMA0MaZSzAwE9PJKCCMvTANo5644zc8jBe" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "NQIDAQAB" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "-----END PUBLIC KEY-----" | sudo tee -a /etc/cvmfs/keys/ardc.edu.au/neurodesk.ardc.edu.au.pub \
    && echo "CVMFS_USE_GEOAPI=yes" | sudo tee /etc/cvmfs/config.d/neurodesk.ardc.edu.au.conf \
    && echo 'CVMFS_SERVER_URL="http://203.101.231.144/cvmfs/@fqrn@;http://150.136.239.221/cvmfs/@fqrn@;http://132.145.96.34/cvmfs/@fqrn@;http://140.238.170.185/cvmfs/@fqrn@;http://130.61.74.69/cvmfs/@fqrn@;http://152.67.114.42/cvmfs/@fqrn@"' | sudo tee -a /etc/cvmfs/config.d/neurodesk.ardc.edu.au.conf \
    && echo 'CVMFS_KEYS_DIR="/etc/cvmfs/keys/ardc.edu.au/"' | sudo tee -a /etc/cvmfs/config.d/neurodesk.ardc.edu.au.conf \
    && echo "CVMFS_HTTP_PROXY=DIRECT" | sudo tee  /etc/cvmfs/default.local \
    && echo "CVMFS_QUOTA_LIMIT=5000" | sudo tee -a  /etc/cvmfs/default.local \
    && cvmfs_config setup 

# Add module script
COPY ./config/module.sh /usr/share/

# Install nipype
RUN pip3 install nipype \
    && rm -rf /root/.cache/pip \
    && rm -rf /home/ubuntu/.cache/

# Configure tiling of windows SHIFT-ALT-CTR-{Left,right,top,Bottom} and other openbox desktop mods
COPY ./config/rc.xml /etc/xdg/openbox

# Configure ITKsnap
COPY ./config/.itksnap.org /etc/skel/.itksnap.org
COPY ./config/mimeapps.list /etc/skel/.config/mimeapps.list

# Apply custom bottom panel configuration
COPY ./config/panel /etc/skel/.config/lxpanel/LXDE/panels/panel

# Allow the root user to access the sshfs mount
# https://github.com/NeuroDesk/neurodesk/issues/47
RUN sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf

# Fetch singularity bind mount list
RUN mkdir -p `curl https://raw.githubusercontent.com/NeuroDesk/neurocontainers/master/recipes/globalMountPointList.txt`

# Install singularity
ARG GO_VERSION
ARG SINGULARITY_VERSION
RUN export VERSION=${GO_VERSION} OS=linux ARCH=amd64 \
    && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz \
    && sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz \
    && rm go$VERSION.$OS-$ARCH.tar.gz \
    && export GOPATH=${HOME}/go \
    && export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin \
    && mkdir -p $GOPATH/src/github.com/sylabs \
    && cd $GOPATH/src/github.com/sylabs \
    && wget https://github.com/sylabs/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-ce-${SINGULARITY_VERSION}.tar.gz \
    && tar -xzvf singularity-ce-${SINGULARITY_VERSION}.tar.gz \
    && cd singularity-ce-${SINGULARITY_VERSION} \
    && ./mconfig -p /usr/local/singularity \
    && make -C builddir \
    && make -C builddir install \
    && rm -rf /usr/local/go $GOPATH 

# Setup module system & singularity
COPY ./config/.bashrc /tmp/.bashrc
RUN cat /tmp/.bashrc >> /etc/skel/.bashrc && rm /tmp/.bashrc \
    && directories=`curl https://raw.githubusercontent.com/NeuroDesk/caid/master/recipes/globalMountPointList.txt` \
    && mounts=`echo $directories | sed 's/ /,/g'` \
    && echo "export SINGULARITY_BINDPATH=${mounts},/neurodesktop-storage" >> /etc/skel/.bashrc

# add Globus client
WORKDIR /opt/globusconnectpersonal
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        tk \
        tcllib \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz \
    && tar xzf globusconnectpersonal-latest.tgz \
    && rm -rf globusconnectpersonal-latest.tgz

# Desktop styling
COPY config/desktop_wallpaper.jpg /usr/share/lxde/wallpapers/desktop_wallpaper.jpg
COPY config/pcmanfm.conf /etc/xdg/pcmanfm/LXDE/pcmanfm.conf
COPY config/lxterminal.conf /usr/share/lxterminal/lxterminal.conf

# Change firefox home
RUN echo 'pref("browser.startup.homepage", "http://neurodesk.github.io", locked);' >> /etc/firefox/syspref.js \
    && echo 'pref("browser.startup.firstrunSkipsHomepage", true, locked);' >> /etc/firefox/syspref.js \
    && echo 'pref("startup.homepage_welcome_url", "http://neurodesk.github.io", locked);' >> /etc/firefox/syspref.js \
    && echo 'pref("browser.aboutwelcome.enabled", true, locked);' >> /etc/firefox/syspref.js

# Create link to persistent storage on Desktop (This needs to happen before the users gets created!)
RUN mkdir -p /etc/skel/Desktop/ \
    && ln -s /neurodesktop-storage /etc/skel/Desktop/

RUN mkdir /neurodesktop-storage && chown -R jovyan:users /neurodesktop-storage

USER jovyan
WORKDIR /home/jovyan

# Link vscode config to persistant storage
RUN mkdir -p /home/user/.config \
    && ln -s /neurodesktop-storage/.config/Code .config/Code \
    && ln -s /neurodesktop-storage/.vscode .vscode

# Create user account with password-less sudo abilities and vnc user
RUN mkdir /home/jovyan/.vnc \
    && chown jovyan /home/jovyan/.vnc \
    && /usr/bin/printf '%s\n%s\n%s\n' 'password' 'password' 'n' | vncpasswd

# Install Apache Tomcat
ARG TOMCAT_REL
ARG TOMCAT_VERSION
RUN wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_REL}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /tmp \
    && mv /tmp/apache-tomcat-${TOMCAT_VERSION} /home/jovyan/tomcat \
    && rm -rf /home/jovyan/tomcat/webapps/* \
    && wget "https://apache.mirror.digitalpacific.com.au/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-1.3.0.war" -O /home/jovyan/tomcat/webapps/ROOT.war

RUN pip install jupyter-server-proxy
COPY config/jupyter_notebook_config.py  /home/jovyan/.jupyter

COPY --chown=jovyan:users config/neurodesktop.sh /home/jovyan
RUN chmod +x /home/jovyan/neurodesktop.sh

# Install neurodesk
ADD "http://api.github.com/repos/NeuroDesk/neurocommand/commits/main" /tmp/skipcache
RUN rm /tmp/skipcache \
    && git clone https://github.com/NeuroDesk/neurocommand.git /neurocommand \
    && cd /neurocommand \
    && bash build.sh --lxde --edit \
    && bash install.sh \
    && ln -s /neurodesktop-storage/containers /neurocommand/local/containers 
