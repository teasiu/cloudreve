FROM alpine:latest
LABEL Maintainer="ecoo.top <teasiu@163.com>"
LABEL Description="cloudreve in hinas"
WORKDIR /cloudreve

RUN apk update \
    && apk add --no-cache tzdata wget aria2 \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /cloudreve/aria2 \
    && mkdir -p /usr/local/aria2 \
    && chmod -R 766 /cloudreve/aria2

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
        wget -q -O cloudreve https://dl.ecoo.top/update/soft_init/cloudreve/cloudreve-armhf; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        wget -q -O cloudreve https://dl.ecoo.top/update/soft_init/cloudreve/cloudreve-arm64; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        wget -q -O cloudreve https://dl.ecoo.top/update/soft_init/cloudreve/cloudreve-amd64; \
    else \
        echo "Unsupported platform: $TARGETPLATFORM"; \
        exit 1; \
    fi

COPY aria2c /usr/bin/
COPY setup/ /usr/local/aria2/
RUN chmod +x /usr/local/aria2/* \
	&& chmod +x /usr/bin/aria2c \
	&& chmod +x cloudreve

EXPOSE 5212
EXPOSE 6800

VOLUME ["/cloudreve/uploads", "/cloudreve/aria2"]

ENTRYPOINT ["sh", "-c", "aria2c --conf-path=/usr/local/aria2/aria2.conf --daemon && ./cloudreve"]
