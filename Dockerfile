FROM alpine

RUN apk add --no-cache git openssh-client yq

ADD *.sh /

RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]
