FROM alpine:latest
LABEL Maintainer="ecoo.top <teasiu@163.com>"
LABEL Description="cloudreve in hinas"
WORKDIR /cloudreve

RUN apk update \
    && apk add --no-cache tzdata wget aria2 \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /opt/cloudreve/aria2 \
    && mkdir -p /usr/local/aria2 \
    && chmod -R 766 /opt/cloudreve/aria2

RUN wget -q -O cloudreve-amd64.tar.gz https://dl.ecoo.top/update/soft_init/cloudreve/cloudreve-amd64.tar.gz \
	&& tar -zxf cloudreve-amd64.tar.gz -C /cloudreve \
	&& rm cloudreve-amd64.tar.gz

COPY aria2c /usr/bin/
COPY setup/ /usr/local/aria2/
RUN chmod +x /usr/local/aria2/* \
	&& chmod +x /usr/bin/aria2c

EXPOSE 5212
EXPOSE 6800

VOLUME ["/cloudreve/uploads", "/opt/cloudreve"]

ENTRYPOINT ["sh", "-c", "aria2c --conf-path=/usr/local/aria2/aria2.conf --daemon && ./cloudreve"]
