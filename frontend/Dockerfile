# Declare build arguments
ARG BASE_API_URL
ARG ASSISTANT_API_URL
ARG ASSISTANT_API_KEY
ARG SENTRY_DSN
ARG SENTRY_TRACE_SAMPLE_RATE
ARG ASSISTANT_SUPERADMIN_API_EMAIL
ARG ASSISTANT_SUPERADMIN_API_PASSWORD
ARG WS_URL
ARG LIVEKIT_URL
ARG AMPLITUDE_API_KEY
ARG AMPLITUDE_PROJECT

# Stage 1: Build the Flutter application
FROM cirrusci/flutter:stable as builder

# Pass build arguments to this stage
ENV BASE_API_URL=${BASE_API_URL}
ENV ASSISTANT_API_URL=${ASSISTANT_API_URL}
ENV ASSISTANT_API_KEY=${ASSISTANT_API_KEY}
ENV SENTRY_DSN=${SENTRY_DSN}
ENV SENTRY_TRACE_SAMPLE_RATE=${SENTRY_TRACE_SAMPLE_RATE}
ENV ASSISTANT_SUPERADMIN_API_EMAIL=${ASSISTANT_SUPERADMIN_API_EMAIL}
ENV ASSISTANT_SUPERADMIN_API_PASSWORD=${ASSISTANT_SUPERADMIN_API_PASSWORD}
ENV WS_URL=${WS_URL}
ENV LIVEKIT_URL=${LIVEKIT_URL}
ENV AMPLITUDE_API_KEY=${AMPLITUDE_API_KEY}
ENV AMPLITUDE_PROJECT=${AMPLITUDE_PROJECT}

WORKDIR /app


# Copy and install dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application source code
COPY . .

# Copy the build script and make it executable
COPY build.sh .
RUN chmod +x build.sh

# Run the build script to build the Flutter web app
# This script will use environment variables to create --dart-define flags
RUN ./build.sh

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy the built web application from the builder stage
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

FROM ubuntu:20.04 AS build

# Setup dependencies
RUN apt-get update && apt-get install -y \
    unzip xz-utils git openssh-client curl python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-cache Flutter and dependencies
RUN flutter channel stable && flutter upgrade
RUN flutter config --enable-web
RUN flutter doctor -v

# Copy application files
COPY . /usr/local/bin/app
WORKDIR /usr/local/bin/app

# Fetch dependencies and pre-cache
RUN flutter pub get
RUN flutter build web --release

# Production stage: Use NGINX to serve the app
FROM nginx:alpine AS production

# Copy Flutter web build output to NGINX html directory
COPY --from=build /usr/local/bin/app/build/web /usr/share/nginx/html

# Add NGINX configuration for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the port NGINX will run on
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
