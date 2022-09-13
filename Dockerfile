# syntax=docker/dockerfile:1.3
FROM golang:1.18 AS builder

RUN mkdir /build
ADD Makefile /build
ADD make /build/make
ADD config /build/config
WORKDIR /build

RUN --mount=type=cache,target=/build/build --mount=type=cache,target=/go make build tools

FROM scratch

COPY --from=builder /build/tools /
