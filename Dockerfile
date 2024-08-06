FROM golang:bullseye AS build
# RUN apt-get update && apt-get install -y git wget build-essential

ENV GPHOTOS_CDP_FORK_NAME=Arbuzov
ENV GPHOTOS_CDP_COMMIT_ID=ec92cad7c7f8fde979e3155a11cc960ad6888518
ENV GO111MODULE=on

RUN go install github.com/$GPHOTOS_CDP_FORK_NAME/gphotos-cdp@$GPHOTOS_CDP_COMMIT_ID

FROM dorowu/ubuntu-desktop-lxde-vnc

ENV \
    # Fail if cont-init scripts exit with non-zero code.
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    CRON="" \
    HEALTHCHECK_ID="" \
    HEALTHCHECK_HOST="https://hc-ping.com" \
    PUID="" \
    PGID="" \
    TZ="" \
    GO111MODULE="on" \
    CHROMIUM_USER_FLAGS="--no-sandbox"

RUN apt-get update || true 
RUN apt-get install -y jhead golang

ADD app /app

COPY --from=build /go/bin/gphotos-cdp /usr/bin/
COPY root/ /
