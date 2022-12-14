# syntax=docker/dockerfile:1.3
FROM golang:1.19 AS builder

ARG TOOLS=TOOLS

RUN mkdir /build
ADD Makefile /build
ADD make /build/make
ADD config /build/config
WORKDIR /build

RUN --mount=type=cache,target=/build/build --mount=type=cache,target=/go make ${TOOLS}
