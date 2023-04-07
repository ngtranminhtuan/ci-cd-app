FROM python:3.9-alpine3.13
LABEL maintainer="845261"

ENV PYTHONUNBUFFERED 1

# ENV http_proxy 'http://proxy.mei.co.jp:8080'
# ENV https_proxy 'http://proxy.mei.co.jp:8080'

# RUN apk update && \
#     apk add build-base
# RUN apk update && apk add --no-cache postgresql-dev
# RUN apk add linux-headers

RUN apt-get update && \
    apt-get install -y libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip setuptools && \
    /py/bin/pip install --use-pep517 uwsgi psycopg2 && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user