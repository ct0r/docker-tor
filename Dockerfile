FROM alpine:latest AS build

# TODO: Check signature
RUN TOR_FILE="tor-0.4.5.6" \
    && apk --no-cache add --update build-base libevent-dev libressl-dev zlib-dev \
    && wget -q "https://dist.torproject.org/$TOR_FILE.tar.gz" \
    && tar -xf "$TOR_FILE.tar.gz" \
    && cd $TOR_FILE \
    && ./configure \
    && make install

FROM alpine:latest

RUN apk --no-cache add --update libevent libressl zlib

COPY --from=build /usr/local /usr/local

# TODO: Run as non-root user
# RUN addgroup -S tor && adduser -SG tor tor
# USER tor

CMD ["tor"]
