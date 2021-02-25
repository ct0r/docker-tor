FROM alpine:latest AS build

# TODO: Find latest version
ENV TOR_VERSION="0.4.5.6"
ENV KEY_SERVER="ha.pool.sks-keyservers.net"

RUN apk --no-cache add --update build-base gnupg libevent-dev libressl-dev zlib-dev \
    && wget -q "https://dist.torproject.org/tor-$TOR_VERSION.tar.gz" \
    && wget -q "https://dist.torproject.org/tor-$TOR_VERSION.tar.gz.asc" \
    && gpg --keyserver $KEY_SERVER --receive-keys "0x6AFEE6D49E92B601" \
    && gpg --verify "tor-$TOR_VERSION.tar.gz.asc" \
    && tar -xf "tor-$TOR_VERSION.tar.gz" \        
    && cd "tor-$TOR_VERSION" \
    && ./configure \
    && make install


FROM alpine:latest

RUN apk --no-cache add --update libevent libressl zlib

COPY --from=build /usr/local /usr/local

# TODO: Run as non-root user
# RUN addgroup -S tor && adduser -SG tor tor
# USER tor

CMD ["tor"]
