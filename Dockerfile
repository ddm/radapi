FROM node

RUN apt-get update && apt-get upgrade -y && apt-get install -y git

ADD provision.sh /usr/sbin/
RUN /usr/sbin/provision.sh

EXPOSE 1880

USER radapi
WORKDIR /opt/radapi/
ENTRYPOINT npm start
