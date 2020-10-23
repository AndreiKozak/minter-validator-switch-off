FROM golang:1.13.7 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers
WORKDIR /app
COPY . /app
RUN go mod download
RUN go build -o ./builds/linux/switcher ./cmd/switch.go

FROM alpine:3.7

COPY --from=builder /app/builds/linux/switcher /usr/bin/switcher
RUN addgroup minteruser && adduser -D -h /minter -G minteruser minteruser
USER minteruser
WORKDIR /minter
CMD ["/usr/bin/switcher"]
