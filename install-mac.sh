#!/usr/bin/env bash
LINUX="false"
while :; do
	case $1 in
		-l|--install-ei-linux) LINUX="true"
		;;
		*) break
	esac
	shift
done
if [[ $(command -v brew) == "" ]]; then
	echo "Installing Homebrew..."
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
else
	echo "Updating Homebrew..."
	brew update
fi
if [[ $(command -v python2) == "" ]]; then
	echo "Installing Python 2.7..."
	brew install python2
fi
if [[ $(command -v node) == "" ]]; then
	echo "Installing Node.js & npm..."
	brew install node
else
	echo "Checking Node.js & npm versions..."
fi
if [[ $(command -v edge-impulse-daemon) == "" ]]; then
	echo "Installing edge-impulse-cli..."
	npm install -g edge-impulse-cli
else
	echo "Updating edge-impulse-cli..."
	npm update -g edge-impulse-cli
fi
if [[ $LINUX == "true" ]]; then
	if [[ $(command -v edge-impulse-linux) == "" ]]; then
		echo "Installing edge-impulse-linux..."
		npm install -g edge-impulse-linux
	else
		echo "Updating edge-impulse-linux..."
		npm update -g edge-impulse-linux
	fi
fi
