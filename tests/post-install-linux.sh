#!/bin/sh

set +e # Ignore Errors
# set -e # Throw Errors

YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"

assert_contains () {
  # $1: Test name
  # $2: Command
  # $3: Expected output
  # $4: Expected return code
  OUTPUT=$($2 2>&1) # Redirect stderr to stdout
  CODE="$?"
  # echo "$OUTPUT"
  # echo "$CODE"
  if [[ "$OUTPUT" == *"$3"* && "$CODE" == "$4" ]]; then
    echo -e "$GREEN[^_^] $1 passed $NORMAL"
  else
    echo -e "$YELLOW[>_<] $1 failed $NORMAL"
    echo -e "Expected output to contain $YELLOW\"$3\"$NORMAL with return code $YELLOW$4$NORMAL
             but got $YELLOW\"$OUTPUT\"$NORMAL with return code $YELLOW$CODE$NORMAL"
    exit 1
  fi
}

assert_contains "Daemon version" \
                "edge-impulse-daemon --version" \
                "1." \
                0
assert_contains "Uploader version" \
                "edge-impulse-uploader --version" \
                "1." \
                0
assert_contains "Forwarder version" \
                "edge-impulse-data-forwarder --version" \
                "1." \
                0
assert_contains "Upload with fake key" \
                "edge-impulse-uploader --api-key notarealkey --category training path/to/file.wav" \
                "Invalid API key" \
                1
