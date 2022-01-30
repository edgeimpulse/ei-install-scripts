#!/bin/sh

YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"

CLI_STRING="Edge Impulse CLI"
BUILD_TOOLS_STRING="Build Tools"
PY_REQ_STR="Python 3.7 or higher"
# PY_INSTALL_STR="Python 3.9"
NODE_REQ_STR="Node.js v12 or higher"
# NODE_INSTALL_STR="Node.js v14"

success () {
  echo ""
  echo -e "$GREEN[^_^] $* $NORMAL"
  echo ""
}

warning () {
  echo ""
  echo -e "$YELLOW[>_<] $* $NORMAL"
  echo ""
}

error () {
  warning "$*"
  exit 1
}

install_cli () {
  echo "Installing the $CLI_STRING..."
  echo "npm install -g edge-impulse-cli"
  npm install -g edge-impulse-cli
  check_cli
}

check_cli () {
  CLI_VERSION=$(edge-impulse-blocks -V)
  if [[ "$CLI_VERSION" == "1."* ]]; then
	  success "$CLI_STRING $CLI_VERSION installed!"
    exit
  else
    warning "$CLI_STRING is not installed."
  fi
}

install_node () {
  error "TODO: Install $NODE_REQ_STR!"
}

install_python () {
  error "TODO: Install $PY_REQ_STR!"
}

install_buildtools () {
  error "TODO: Install $BUILD_TOOLS_STRING!"
}

version () { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

check_node () {
  echo "Checking if you have $NODE_REQ_STR installed..."
  NODE_VERSION=$(node --version)
  if [ -z $NODE_VERSION ]; then
    install_node
  else
    NODE_VERSION=${NODE_VERSION/"v"/""}
    if [ $(version $NODE_VERSION) -lt $(version "12") ]; then
      install_node
    fi
  fi
  NODE_VERSION=$(node --version)
  success "Node.js $NODE_VERSION installed!"
}

check_python () {
  echo "Checking if you have $PY_REQ_STR installed..."
  PYTHON_VERSION=$(python --version)
  if [ -z "$PYTHON_VERSION" ]; then
    install_python
  else
    PYTHON_VERSION=${PYTHON_VERSION/"Python "/""}
    PYTHON_VERSION=${PYTHON_VERSION/"python "/""}

    case $PYTHON_VERSION in

      "2"*)
        if [ $(version $PYTHON_VERSION) -lt $(version "2.7") ]; then
          install_python
        fi
        ;;

      "3"*)
        if [ $(version $PYTHON_VERSION) -lt $(version "3.7") ]; then
          install_python
        fi
        ;;

      *)
        install_python
        ;;
    esac

  fi
  PYTHON_VERSION=$(python --version)
  success "$PYTHON_VERSION installed!"
}

warning "TODO: Check that we are running with privileges!"
check_cli
check_node
check_python
# install_buildtools
install_cli

