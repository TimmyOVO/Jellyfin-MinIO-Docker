
FROM alpine:3.9 as min-io-downloader
WORKDIR /root

RUN apk add axel
RUN wget https://dl.min.io/server/minio/release/linux-amd64/minio

FROM jellyfin/jellyfin:latest

WORKDIR /oss
COPY . /oss/

COPY --from=min-io-downloader /root /oss

RUN ls -a /oss
RUN touch /oss/entry_point
RUN mkdir files
RUN chmod +x /oss/entry_point
RUN chmod +x /oss/minio

ENV MINIO_ROOT_USER admin
ENV MINIO_ROOT_PASSWORD password
ENV MINIO_DIRECTORY /files

EXPOSE 8096
EXPOSE 9000

ENTRYPOINT ["sh","/oss/entry_point"]
