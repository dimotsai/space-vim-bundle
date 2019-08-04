#!/usr/bin/env bash

set -ex

INIT_VIM=../../.space-vim/init.vim
NVIMRC=~/.config/nvim/init.vim
VIMRC=~/.vimrc
PLUGS_VIM=~/.plugs.vim

python3 -m pip install --user pynvim
python3 -m pip install --user python-language-server[all]
if ! [ -d ~/.space-vim ]; then \
  git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
fi
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "call plug#begin('~/.vim/plugged')" > $PLUGS_VIM
./plug-parser.py $(find ~/.space-vim/layers -name 'packages.vim') >> $PLUGS_VIM
echo "call plug#end()" >> $PLUGS_VIM
cd ~/.space-vim
mkdir -p ~/.config/nvim
[ ! -f $NVIMRC ] && ln -sf $INIT_VIM $NVIMRC
nvim -u $PLUGS_VIM +'PlugInstall' +qall
nvim +'PlugInstall' +qall
rm -f $PLUGS_VIM
rm -f ~/.fzf.{bash,zsh} ~/{.bashrc,.zshrc}
