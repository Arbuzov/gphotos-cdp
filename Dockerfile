FROM golang:bullseye AS build

ENV GO111MODULE=on

WORKDIR /gphotos-cdp

COPY . .

RUN go install

FROM dorowu/ubuntu-desktop-lxde-vnc

ENV GO111MODULE="on"
ENV CHROMIUM_USER_FLAGS="--no-sandbox"

RUN apt-get update || true
RUN apt-get install -y ffmpeg

COPY --from=build /go/bin/gphotos-cdp /usr/bin/

ADD --chmod=777 scripts/sync-photo /usr/bin/sync-photo

ENTRYPOINT ["/bin/bash"]
