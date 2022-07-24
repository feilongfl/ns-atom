# Container image that runs your code
FROM alpine

# Install dep
RUN apk add alpine-sdk pacman-makepkg make p7zip zstd xz sudo

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
