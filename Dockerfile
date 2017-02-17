FROM node:alpine

RUN apk add --update-cache git

ADD provision.sh /usr/sbin/
RUN /usr/sbin/provision.sh

EXPOSE 1880

USER radapi
WORKDIR /opt/radapi/
ENTRYPOINT ["npm"]
CMD ["start"]
