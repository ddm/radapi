FROM dimdm/node

COPY *.js* .bowerrc /opt/radapi/
COPY public/* /opt/radapi/public/

RUN apk --no-cache add --virtual build-dependencies \
      git &&\
    mkdir -p /opt/radapi/data &&\
    cd /opt/radapi &&\
    npm config set unsafe-perm true &&\
    npm install &&\
    apk del --purge build-dependencies &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /root/* &&\
    rm -rf /tmp/* &&\
    adduser -D -u 1000 radapi &&\
    chown -R radapi:radapi /opt/radapi

EXPOSE 1880
USER radapi
WORKDIR /opt/radapi/
CMD npm start

