#!/bin/sh

# Initialize an empty string for dart-define arguments
DART_DEFINES=""

# List of environment variables to check
ENV_VARS="
BASE_API_URL
ASSISTANT_API_URL
ASSISTANT_API_KEY
ASSISTANT_SUPERADMIN_API_EMAIL
ASSISTANT_SUPERADMIN_API_PASSWORD
SENTRY_DSN
SENTRY_TRACE_SAMPLE_RATE
ENVIRONMENT
SENTRY_RELEASE_NAME
WS_URL
LIVEKIT_URL
AMPLITUDE_API_KEY
AMPLITUDE_PROJECT
"

# Loop through the variables and build the --dart-define string
for VAR in $ENV_VARS
do
  # Get the value of the variable.
  VALUE=$(eval echo \$$VAR)
  
  # If the variable is set, add it to the dart-defines
  if [ -n "$VALUE" ]; then
    DART_DEFINES="$DART_DEFINES --dart-define=$VAR=$VALUE"
  fi
done

# Run the flutter build command with the dynamic dart-defines
sh -c "flutter build web --release $DART_DEFINES"
