FROM python:3.9-alpine3.13
LABEL maintainer="test.com"

ENV PYTHONUNBUFFERED 1

# Copy requirements.txt and the app files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose port if needed
EXPOSE 8000

# Install dependencies, create user, and set permissions
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp/* && \
    adduser -D django-user

# Add /py/bin to PATH
ENV PATH="/py/bin:$PATH"

# Switch to non-root user
USER django-user

# CMD or ENTRYPOINT command goes here
# -D is used to create a user without a password and without creating a home directory. This is different from other distributions where --disable-password and --no-create-home options might be available.