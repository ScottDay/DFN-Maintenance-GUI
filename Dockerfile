# Prod docker file.
FROM python:3.6-alpine

WORKDIR /
COPY build/ /

RUN apk add --no-cache --virtual pynacl_deps build-base python3-dev libffi-dev libressl-dev libssh2-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del pynacl_deps

EXPOSE 5000
CMD [ "gui.py", "--docker" ]