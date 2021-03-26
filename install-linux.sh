#!/bin/sh
LINUX="false"
while :; do
	case $1 in
		-l|--install-ei-linux) LINUX="true"
		;;
		*) break
	esac
	shift
done
sudo apt-get update && sudo apt-get install -y curl gcc g++ make python build-essential sox ffmpeg
if ! [ -x "$(command -v node)" ]; then
	echo "Installing Node.js & npm..."
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	node -v
fi
NPM_PREFIX=$(npm config get prefix)
echo "npm prefix = " $NPM_PREFIX
if [ $NPM_PREFIX = '/usr/local' ] || [ $NPM_PREFIX = '/usr' ]; then
	echo "Setting npm prefix to ~/.npm-global ..."
	mkdir ~/.npm-global
	npm config set prefix '~/.npm-global'
	echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
fi
if ! [ -x "$(command -v edge-impulse-daemon)" ]; then
	echo "Installing edge-impulse-cli..."
	npm install -g edge-impulse-cli
else
	echo "Updating edge-impulse-cli..."
	npm update -g edge-impulse-cli
fi
if [ $LINUX = "true" ]; then
	if ! [ -x "$(command -v edge-impulse-linux)" ]; then
		echo "Installing edge-impulse-linux..."
		npm install -g edge-impulse-linux
	else
		echo "Updating edge-impulse-linux..."
		npm update -g edge-impulse-linux
	fi
fi
