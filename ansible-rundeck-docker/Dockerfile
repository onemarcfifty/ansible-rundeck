FROM rundeck/rundeck:4.4.0

# minimal rundeck with ansible
# no mariadb

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
    apt-get -y install \
        apt-transport-https \
        python3-pip \
        sudo \
        wget \
        curl \
        git \
        nmap

RUN pip install --upgrade pip
RUN pip install ansible

RUN wget https://github.com/coder/code-server/releases/download/v4.6.0/code-server_4.6.0_amd64.deb
RUN apt -y install ./code-server_4.6.0_amd64.deb

USER rundeck

# now make sure the vscode server gets started at runtime
RUN echo 'export PASSWORD=$VSCODE_PASSWORD' >docker-lib/includes/120_vscode.sh
RUN echo 'pidof node || /usr/bin/code-server --host 0.0.0.0 &' >>docker-lib/includes/120_vscode.sh
RUN chmod 755 docker-lib/includes/120_vscode.sh

#VOLUME ["/home/rundeck/server/data"]

#EXPOSE 4440
#ENTRYPOINT [ "docker-lib/entry.sh" ]