FROM mhart/alpine-node:6

# If you have native dependencies, you'll need extra tools
RUN apk add --no-cache bash git openssh

RUN mkdir -p /opt/nodejs && mkdir -p ~/.ssh
COPY package.json /opt/nodejs
WORKDIR /opt/nodejs

RUN npm install --registry=https://registry.npm.taobao.org && \
    rm -f package.json && \
    npm uninstall -g npm && \
    rm -rf /tmp/* && \
    rm -rf /root/.npm

# install phantomjs
ENV PHANTOMJS_ARCHIVE="phantomjs.tar.gz"
RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main'>> /etc/apk/repositories \
	&& apk --update add curl

RUN curl -Lk -o $PHANTOMJS_ARCHIVE https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz \
	&& tar -xf $PHANTOMJS_ARCHIVE -C /tmp/ \
	&& cp -R /tmp/etc/fonts /etc/ \
	&& cp -R /tmp/lib/* /lib/ \
	&& cp -R /tmp/lib64 / \
	&& cp -R /tmp/usr/lib/* /usr/lib/ \
	&& cp -R /tmp/usr/lib/x86_64-linux-gnu /usr/ \
	&& cp -R /tmp/usr/share/* /usr/share/ \
	&& cp /tmp/usr/local/bin/phantomjs /usr/bin/ \
	&& rm -fr $PHANTOMJS_ARCHIVE  /tmp/*

# install msyh
RUN apk --update add fontconfig \
  && curl -L -o msyh.tar.bz2 http://gitlab.tenxcloud.com/public-space/files-sharing/raw/master/fonts/msyh/msyh.tar.bz2 \
  && tar -xjf msyh.tar.bz2 && rm msyh.tar.bz2 \
  && mkdir -p /usr/share/fonts/msyh \
  && cp msyh.ttf /usr/share/fonts/msyh/ \
  && rm -rf msyh.ttf \
  && fc-cache -fv
