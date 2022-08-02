FROM rundeck/rundeck:4.4.0

# minimal rundeck with ansible
# no mariadb

USER root

RUN apt-get -y update && \
    apt-get -y install \
        apt-transport-https \
        python3-pip

RUN pip install --upgrade pip

RUN pip install ansible

USER rundeck


#VOLUME ["/home/rundeck/server/data"]

#EXPOSE 4440
#ENTRYPOINT [ "docker-lib/entry.sh" ]