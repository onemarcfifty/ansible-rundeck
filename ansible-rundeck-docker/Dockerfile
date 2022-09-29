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
        nmap \
        sshpass
RUN apt-get clean
# let's install ansible using pip as root
# this will give a fat red warning at runtime but is intended this way.
RUN pip install --upgrade pip
RUN pip install ansible

# we download the debian package for vscode server from the coder github repo
# and install it with apt
RUN wget https://github.com/coder/code-server/releases/download/v4.6.0/code-server_4.6.0_amd64.deb
RUN apt -y install ./code-server_4.6.0_amd64.deb
RUN apt-get clean
# for compatibility with the non-docker version we just link the
# /var/lib/rundeck directory to the /home/rundeck directory
RUN ln -s /home/rundeck /var/lib/rundeck

USER rundeck

# now make sure the vscode server gets started at runtime
RUN echo 'export PASSWORD=$VSCODE_PASSWORD' >docker-lib/includes/120_vscode.sh
RUN echo 'pidof node || /usr/bin/code-server --host 0.0.0.0 &' >>docker-lib/includes/120_vscode.sh
RUN chmod 755 docker-lib/includes/120_vscode.sh

# make sure we can write to the ansible volume
RUN echo 'sudo chown rundeck:root ansible' >docker-lib/includes/110_volume.sh
RUN echo '/bin/touch ~/ansible/ansible.cfg' >>docker-lib/includes/110_volume.sh
RUN if [ ! -e ~/.ansible.cfg ] ; then ln -s ~/ansible/ansible.cfg ~/.ansible.cfg ; fi
RUN chmod 755 docker-lib/includes/110_volume.sh

#VOLUME ["/home/rundeck/server/data"]

#EXPOSE 4440
#ENTRYPOINT [ "docker-lib/entry.sh" ]