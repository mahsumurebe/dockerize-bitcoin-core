FROM debian:bullseye-slim
LABEL maintainer="Mahsum UREBE <info@mahsumurebe.com>"
LABEL description="Dockerised Bitcoin Core"

ENV COIN_VERSION="0.21.0"
ENV TARBALL_NAME="bitcoin-${COIN_VERSION}"
ENV BINARY_URL="https://bitcoincore.org/bin/bitcoin-core-${COIN_VERSION}/${TARBALL_NAME}-x86_64-linux-gnu.tar.gz"

ENV COIN_ROOT_DIR="/data"
ENV COIN_RESOURCES="${COIN_ROOT_DIR}/resources"
ENV COIN_WALLETS="${COIN_ROOT_DIR}/wallets"
ENV COIN_LOGS="${COIN_ROOT_DIR}/logs"
ENV COIN_SCRIPTS="${COIN_ROOT_DIR}/scripts"
ENV COIN_TMP="${COIN_ROOT_DIR}/tmp"
ENV COIN_CONF_FILE="${COIN_ROOT_DIR}/config.conf"

RUN mkdir -p "${COIN_ROOT_DIR}" \
    & mkdir -p "${COIN_RESOURCES}" \
    & mkdir -p "${COIN_WALLETS}" \
    & mkdir -p "${COIN_LOGS}" \
    & mkdir -p "${COIN_SCRIPTS}" \
    & mkdir -p "${COIN_TMP}"

WORKDIR "${COIN_ROOT_DIR}"

RUN apt-get update -y
RUN apt-get install -y curl gosu ca-certificates apt-transport-https jq bc
RUN apt-get clean

RUN curl -L "${BINARY_URL}" -o "${COIN_TMP}/${TARBALL_NAME}-x86_64-linux-gnu.tar.gz"
RUN tar -C "${COIN_TMP}" -xzvf "${COIN_TMP}/${TARBALL_NAME}-x86_64-linux-gnu.tar.gz"
RUN mv ${COIN_TMP}/${TARBALL_NAME}/bin/* /usr/bin/
RUN mv ${COIN_TMP}/${TARBALL_NAME}/include/* /usr/include/
RUN mv ${COIN_TMP}/${TARBALL_NAME}/lib/* /usr/lib/
RUN mv ${COIN_TMP}/${TARBALL_NAME}/share/* /usr/share/
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* "${COIN_TMP}"
RUN apt-get clean -yqq 2>/dev/null

COPY "docker-entrypoint.sh" /entrypoint.sh
COPY "config.conf" "${COIN_CONF_FILE}"
COPY "scripts/" "${COIN_SCRIPTS}/"
RUN ln -s "${COIN_SCRIPTS}/move.sh" "/usr/bin/move"
RUN groupadd -g 1000 bitcoin \
    && useradd -u 1000 -g bitcoin -m -d /home/bitcoin bitcoin \
    && chown -R bitcoin "${COIN_ROOT_DIR}/"

EXPOSE 8332 18332 18443 8333 18333 18444

VOLUME ["${COIN_ROOT_DIR}"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
