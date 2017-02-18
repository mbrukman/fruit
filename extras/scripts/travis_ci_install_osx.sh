#!/bin/bash -x

set -e

install_brew_package() {
  if brew list -1 | grep -q "^$1\$"; then
    # Package is installed, upgrade if needed
    brew outdated "$1" || brew upgrade "$@"
  else
    # Package not installed yet, install.
    # If there are conflicts, try overwriting the files (these are in /usr/local anyway so it should be ok).
    brew install "$@" || brew link --overwrite gcc49
  fi
}

brew update

# For md5sum
install_brew_package md5sha1sum
# For `timeout'
install_brew_package coreutils

if [[ "${INSTALL_VALGRIND}" == "1" ]]
then
    install_brew_package valgrind
fi

which cmake &>/dev/null || install_brew_package cmake

case "${COMPILER}" in
gcc-4.8)       install_brew_package gcc@4.8 ;;
gcc-4.9)       install_brew_package gcc@4.9 ;;
gcc-5)         install_brew_package gcc@5 ;;
gcc-6)         install_brew_package gcc@6 ;;
clang-default) ;;
clang-3.7)     install_brew_package llvm@3.7 --with-clang --with-libcxx;;
clang-3.8)     install_brew_package llvm@3.8 --with-clang --with-libcxx;;
clang-3.9)     install_brew_package llvm --with-clang --with-libcxx;;
*) echo "Compiler not supported: ${COMPILER}. See travis_ci_install_osx.sh"; exit 1 ;;
esac

brew install python3
pip3 install nose2
pip3 install sh
