FROM dimdm/node:6.10.2

ENV NODE_ENV=production
ARG NODE_ENV=production
ARG RADAPI_PATH=/radapi

COPY package.json .bowerrc bower.json index.js ${RADAPI_PATH}/
COPY public/* ${RADAPI_PATH}/public/

RUN apk --no-cache add --virtual build-dependencies \
      git \
      build-base \
      python &&\
    mkdir -p ${RADAPI_PATH}/data &&\
    cd ${RADAPI_PATH} &&\
    npm config set unsafe-perm true &&\
    npm install &&\
    apk del --purge build-dependencies &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /root/* &&\
    rm -rf /tmp/* &&\
    adduser -D -u 1000 radapi &&\
    chown -R radapi:radapi ${RADAPI_PATH}

VOLUME ${RADAPI_PATH}/data
EXPOSE 1880
USER radapi
WORKDIR ${RADAPI_PATH}
CMD npm start

