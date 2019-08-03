#!/usr/bin/env bash

set -ex

INIT_VIM=../../.space-vim/init.vim
NVIMRC=~/.config/nvim/init.vim
VIMRC=~/.vimrc

python3 -m pip install --user pynvim
python3 -m pip install --user python-language-server[all]
if ! [ -d ~/.space-vim ]; then \
  git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
fi
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "call plug#begin('~/.vim/plugged')" > ~/plugs.vim
./plug-parser.py $(find ~/.space-vim/layers -name 'packages.vim') >> ~/plugs.vim
echo "call plug#end()" >> ~/plugs.vim
cd ~/.space-vim
cp ../../template/.spacevim ~/.spacevim
mkdir -p ~/.config/nvim
[ ! -f $NVIMRC ] && ln -sf $INIT_VIM $NVIMRC
nvim -u ~/plugs.vim +'PlugInstall' +qall
