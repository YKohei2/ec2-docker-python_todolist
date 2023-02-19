# Test stage
FROM alpine:3.13.5 AS test
LABEL application=todobackend

# Install basic utilities
RUN apk add --no-cache bash git

# Install build dependencies
RUN apk add --no-cache gcc python3-dev py3-pip libffi-dev musl-dev linux-headers mariadb-dev
RUN pip3 install wheel -U