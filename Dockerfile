FROM node:alpine

COPY *.js* /opt/radapi/
COPY .bowerrc /opt/radapi/
COPY public/*.html /opt/radapi/public/

RUN apk add --update-cache git &&\
    mkdir -p /opt/radapi/data &&\
    cd /opt/radapi &&\
    npm config set unsafe-perm true &&\
    npm install &&\
    adduser radapi || echo "" &&\
    chown -R radapi:radapi /opt/radapi

EXPOSE 1880
USER radapi
WORKDIR /opt/radapi/
ENTRYPOINT ["npm"]
CMD ["start"]
