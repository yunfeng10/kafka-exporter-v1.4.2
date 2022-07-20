FROM golang:1.17.12 as build

WORKDIR /go/src/danielqsj/kafka_exporter

COPY go.mod .
COPY go.sum .
COPY kafka_exporter.go .
COPY scram_client.go .
RUN go mod download
RUN GOARCH=amd64 CGO_ENABLED=0 go build -o kafka_exporter

FROM quay.io/prometheus/busybox:latest

COPY --from=build /go/src/danielqsj/kafka_exporter/kafka_exporter /bin/kafka_exporter

EXPOSE     9308
ENTRYPOINT [ "/bin/kafka_exporter" ]