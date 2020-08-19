ARG         ALPINE_VERSION="${ALPINE_VERSION:-3.12}"
FROM        alpine:"${ALPINE_VERSION}"

LABEL       maintainer="https://github.com/hermsi1337"
LABEL       fork_maintainer="https://github.com/pseudojo"

ARG         OPENSSH_VERSION="${OPENSSH_VERSION:-8.3_p1-r0}"
ARG         SSHPASS_VERSION="${SSHPASS_VERSION:-1.06-r0}"
ARG         CURL_VERSION="${CURL_VERSION:-7.69.1-r0}"
ENV         CONF_VOLUME="/conf.d"
ENV         OPENSSH_VERSION="${OPENSSH_VERSION}" \
            CURL_VERSION="${CURL_VERSION}" \
            CACHED_SSH_DIRECTORY="${CONF_VOLUME}/ssh" \
            AUTHORIZED_KEYS_VOLUME="${CONF_VOLUME}/authorized_keys" \
            ROOT_KEYPAIR_LOGIN_ENABLED="false" \
            ROOT_LOGIN_UNLOCKED="false" \
            USER_LOGIN_SHELL="/bin/bash" \
            USER_LOGIN_SHELL_FALLBACK="/bin/ash"

RUN         apk add --upgrade --no-cache \
                    bash \
                    bash-completion \
                    rsync \
                    openssh=${OPENSSH_VERSION} \
                    sshpass=${SSHPASS_VERSION} \
                    curl=${CURL_VERSION} \
                   
            && \
            mkdir -p /root/.ssh "${CONF_VOLUME}" "${AUTHORIZED_KEYS_VOLUME}" \
            && \
            cp -a /etc/ssh "${CACHED_SSH_DIRECTORY}" \
            && \
            rm -rf /var/cache/apk/*

COPY        entrypoint.sh /
COPY        conf.d/etc/ /etc/
EXPOSE      22
VOLUME      ["/etc/ssh"]
ENTRYPOINT  ["/entrypoint.sh"]
