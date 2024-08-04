FROM alpine

RUN apk add --no-cache git openssh-client yq

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]