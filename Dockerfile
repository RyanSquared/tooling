# syntax=docker/dockerfile:1.3
ARG TOOLS=TOOLS

FROM golang:1.20 AS builder

RUN mkdir /build
ADD Makefile /build
ADD make /build/make
ADD config /build/config
WORKDIR /build

FROM builder AS make-invocation

RUN --mount=type=cache,target=/build/build --mount=type=cache,target=/go make ${TOOLS}

FROM scratch AS output

COPY --from=make-invocation /build/tools /
