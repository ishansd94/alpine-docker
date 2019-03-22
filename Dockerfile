ARG ALPINE_VERSION=latest
ARG SECRETS_DIR="/run/secrets"
ARG USER="alpine"
ARG USER_GROUP="alpineapp"

FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Ishan Dassanayake"
LABEL Version=1.0.0

ARG USER
ARG USER_GROUP="alpineapp"
ARG SECRETS_DIR

RUN apk --no-cache update && \
    rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin

RUN addgroup -S ${USER_GROUP} && adduser -S ${USER} -G ${USER_GROUP}

USER ${USER}

WORKDIR /home/${USER}

ENV CURRENT_USER ${USER}

ENV PATH ${PATH}:/home/${USER}/.local/bin

COPY scripts .scripts

COPY VERSION .

ENTRYPOINT [ "docker-entrypoint.sh" ]