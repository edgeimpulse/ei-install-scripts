#!/usr/bin/env bash
if test ! $(which brew); then
	echo "Installing homebrew..."
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
fi
if test ! $(which python2); then
	echo "Installing Python 2.7..."
	brew install python2
fi
if test ! $(which node); then
	echo "Installing Node.js & npm..."
	brew install node
fi
if test ! $(which edge-impulse-daemon); then
	echo "Installing edge-impulse-cli..."
	npm install -g edge-impulse-cli
else
	echo "Updating edge-impulse-cli..."
	npm update -g edge-impulse-cli
fi
if test ! $(which edge-impulse-linux); then
	echo "Installing edge-impulse-linux..."
	npm install -g edge-impulse-linux
else
	echo "Updating edge-impulse-linux..."
	npm update -g edge-impulse-linux
fi
