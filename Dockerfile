FROM node:alpine

RUN apk add --update-cache git &&\
    git clone --depth 1 https://github.com/ddm/radapi /opt/radapi &&\
    mkdir -p /opt/radapi/data &&\
    cd /opt/radapi &&\
    npm install && \
    adduser radapi || echo "" &&\
    chown -R radapi:radapi /opt/radapi

EXPOSE 1880

USER radapi
WORKDIR /opt/radapi/
ENTRYPOINT ["npm"]
CMD ["start"]
