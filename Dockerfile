FROM python:3.9-alpine3.13

# Environment variable to avoid Python buffering its output
ENV PYTHONUNBUFFERED 1

# Install build dependencies
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev \
    build-base \
    postgresql-dev \
    jpeg-dev \
    zlib-dev

# Copy the requirements and application code
COPY ./requirements.txt /temp/requirements.txt
COPY ./requirements.dev.txt /temp/requirements.dev.txt
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose the default Django port
EXPOSE 8000

ARG DEV=false
# Create a virtual environment, upgrade pip, install dependencies, and clean up
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /temp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /temp/requirements.dev.txt ; \
    fi && \
    rm -rf /temp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Ensure the virtual environment is activated by default
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user
