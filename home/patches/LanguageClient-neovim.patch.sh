#!/usr/bin/env bash

cd $HOME/vim/plugged/LanguageClient-neovim

git fetch
git checkout 0.1.146
./install.sh
