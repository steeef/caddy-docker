FROM alpine:3.3
MAINTAINER Stephen Price <steeef@gmail.com>

LABEL caddy_version="0.8.2" architecture="amd64"
ENV HUGO_VERSION=0.15
ENV CADDY_FEATURES=git

RUN apk add --update openssh-client git tar

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${CADDY_FEATURES}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

RUN apk add --update wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  tar xzf hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  mv hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/bin/hugo && \
  rm -r hugo_${HUGO_VERSION}_linux_amd64 && \
  apk del wget tar && \
  rm /var/cache/apk/*

EXPOSE 80 443 2015
VOLUME /srv
WORKDIR /srv

ADD Caddyfile /etc/Caddyfile
ADD index.html /srv/index.html

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
