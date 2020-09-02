FROM golang:1.14-alpine AS base
RUN apk update && apk add ffmpeg git

FROM base as build

RUN mkdir -p /opt/m2mconvert
ADD go.mod /opt/m2mconvert
ADD main.go /opt/m2mconvert

WORKDIR "/opt/m2mconvert"
RUN go mod tidy
RUN go build .
RUN go install .

VOLUME ["/mnt/src", "/mnt/dst"]

FROM build
ENTRYPOINT [ "m2mconvert" ]

