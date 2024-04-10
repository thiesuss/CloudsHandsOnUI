FROM golang:1.19 AS build
WORKDIR /go/src
COPY go ./go
COPY main.go .
COPY go.sum .
COPY go.mod .

ENV CGO_ENABLED=0

RUN go build -o openapi .

# Use alpine instead of scratch
FROM alpine:latest AS runtime
# Install CA certificates
RUN apk --no-cache add ca-certificates
COPY --from=build /go/src/openapi ./
EXPOSE 80/tcp
ENTRYPOINT ["./openapi"]
