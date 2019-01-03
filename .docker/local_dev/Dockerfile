FROM keymetrics/pm2:latest-alpine as Base

LABEL author="Stephen Cirelli"
LABEL maintainer="stephen.cirelli@capitalone.com"
LABEL description="Scraper API docker container nodejs dev environment."

ENV CONTAINER_INSTALL_DIR="/code"
ENV PORT=80

RUN apk add --no-cache bash

WORKDIR $CONTAINER_INSTALL_DIR

EXPOSE $PORT 9229 9222 9221

CMD ["npm", "run-script", "docker:start:docker-cmd"]
