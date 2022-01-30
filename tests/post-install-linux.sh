#!/bin/sh

echo "👉🏽 Test daemon"
set -e # Throw Errors
edge-impulse-daemon --version

echo "👉🏽 Test uploader"
set +e # Ignore Errors
OUTPUT=$(edge-impulse-uploader --api-key notarealkey --category training path/to/file.wav 2>&1)
echo $OUTPUT
if [[ "$OUTPUT" == *"Invalid API key"* ]]; then
    echo "Upload failed with invalid credentials as expected!"
else
    echo "Expected invalid credentials failure but instead got:"
    echo "$OUTPUT!"
    exit 1
fi
