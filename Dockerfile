# Stage 1: Build dependencies
FROM python:alpine3.18 AS builder
WORKDIR /code
COPY ./requirements.txt /code/

# Install build tools and Rust compiler & remove unnecessary packages after installation
RUN apk --no-cache add build-base gcc musl-dev python3-dev rust cargo && \
    pip3 wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt && \
    apk del build-base gcc musl-dev python3-dev rust cargo


# Stage 2: Final image
FROM python:alpine3.18
WORKDIR /code
COPY --from=builder /wheels /wheels
COPY --from=builder /code/requirements.txt .

# Install dependencies using pre-built wheels
RUN pip3 install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt && \
    rm -rf /wheels

# Copy the application
COPY . /code/

# Add non-root user for safety
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose application port
EXPOSE 8000

# CMD to run the application on host 0.0.0.0 and port 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
