FROM alpine

RUN apk add --no-cache git openssh-client

COPY *.sh /

RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]