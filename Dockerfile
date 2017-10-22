FROM dimdm/node:8.7.0-arm32v6

ENV NODE_ENV=production
ARG NODE_ENV=production
ARG RADAPI_PATH=/radapi

COPY package.json yarn.lock .bowerrc bower.json index.js ${RADAPI_PATH}/
COPY public/* ${RADAPI_PATH}/public/
COPY nrgpio /usr/local/bin/
ADD https://raw.githubusercontent.com/node-red/catalogue.nodered.org/master/catalogue.json ${RADAPI_PATH}/public/

WORKDIR ${RADAPI_PATH}
RUN apk --no-cache add --virtual runtime-dependencies \
      python &&\
    apk --no-cache add --virtual build-dependencies \
      git \
      build-base \
      python-dev \
      py-pip \
      yarn &&\
    mkdir -p ${RADAPI_PATH}/data &&\
    cd ${RADAPI_PATH} &&\
    yarn add bower &&\
    yarn &&\
    yarn remove bower &&\
    pip install rpi.gpio &&\
    apk del --purge build-dependencies &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/* &&\
    addgroup -g 1000 radapi &&\
    adduser -u 1000 -G radapi -s /bin/sh -D radapi &&\
    chown -R radapi:radapi ${RADAPI_PATH}

VOLUME ${RADAPI_PATH}/data
VOLUME ${RADAPI_PATH}/public

EXPOSE 1880

USER radapi

CMD npm start
