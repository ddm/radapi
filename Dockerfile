FROM dimdm/node:8.7.0-arm32v6

ENV NODE_ENV=production
ARG NODE_ENV=production
ARG RADAPI_PATH=/radapi

COPY package.json yarn.lock .bowerrc bower.json index.js ${RADAPI_PATH}/
COPY public/* ${RADAPI_PATH}/public/
ADD https://raw.githubusercontent.com/node-red/catalogue.nodered.org/master/catalogue.json ${RADAPI_PATH}/public/

WORKDIR ${RADAPI_PATH}
RUN apk --no-cache add --virtual runtime-dependencies \
      bash \
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
    rm -rf /tmp/*

VOLUME ${RADAPI_PATH}/data
VOLUME ${RADAPI_PATH}/public
VOLUME /dev/mem
VOLUME /sys/class/gpio

EXPOSE 1880

CMD npm start

