FROM arm32v6/alpine:3.10.2

ARG NODE_ENV=production
ARG RADAPI_PATH=/radapi

COPY package.json yarn.lock .bowerrc bower.json index.js ${RADAPI_PATH}/
COPY public/* ${RADAPI_PATH}/public/
ADD https://raw.githubusercontent.com/node-red/catalogue.nodered.org/master/catalogue.json ${RADAPI_PATH}/public/

WORKDIR ${RADAPI_PATH}
RUN apk --no-cache add \
      git \
      nodejs \
      python \
      build-base \
      linux-headers \
      python-dev \
      py-pip \
      yarn &&\
    pip install rpi.gpio &&\
    mkdir -p ${RADAPI_PATH}/data &&\
    cd ${RADAPI_PATH} &&\
    yarn global add bower &&\
    yarn global add node-gyp &&\
    yarn

FROM arm32v6/alpine:3.10.2

ARG RADAPI_PATH=/radapi

COPY --from=0 ${RADAPI_PATH} ${RADAPI_PATH}
COPY --from=0 /usr/lib/python2.7/site-packages/RPi /usr/lib/python2.7/site-packages/RPi

RUN apk --no-cache add --virtual runtime-dependencies \
      nodejs \
      npm \
      bash \
      python &&\
    cp ${RADAPI_PATH}/node_modules/@node-red/nodes/core/hardware/nrgpio.py /usr/bin/nrgpio

WORKDIR ${RADAPI_PATH}

ENV NODE_ENV=production
VOLUME ${RADAPI_PATH}/data
VOLUME ${RADAPI_PATH}/public
VOLUME /dev/mem
VOLUME /sys/class/gpio

EXPOSE 1880

CMD npm start

