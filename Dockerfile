FROM ghcr.io/falcondev-oss/github-actions-cache-server:latest

RUN apk update && apk add gettext bash docker-cli docker-cli-compose

COPY ./service /etc/service
RUN chmod -R +x /etc/service
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]