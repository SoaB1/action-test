FROM cloudflare/cloudflared:2022.8.2-arm64 as cloudflared-binary

FROM alpine:3.16
ARG TARGETARCH

COPY --from=cloudflared-binary /usr/local/bin/cloudflared /usr/local/bin/

# install yq (see https://github.com/mikefarah/yq/tree/d8abcce633abe7e73ea70ba539b59836505850f1#install)
RUN wget https://github.com/mikefarah/yq/releases/download/v4.16.1/yq_linux_arm64.tar.gz -O -\
    | tar xz && mv yq_linux_arm64 /usr/local/bin/yq

COPY ./entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
