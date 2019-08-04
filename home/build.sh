#!/usr/bin/env bash
set -ex

export PATH=$HOME/.local/bin:$PATH

INIT_VIM=../../.space-vim/init.vim
NVIMRC=~/.config/nvim/init.vim
VIMRC=~/.vimrc
PLUGS_VIM=~/.plugs.vim

# install python dependecies
python3 -m pip install --user pynvim
python3 -m pip install --user python-language-server[all]
python3 -m pip install --user lark-parser
# fix shebangs of python scripts
for exe in $(ls "$HOME/.local/bin/"*); do
    if [[ -f "$exe" ]] && [[ -x "$exe" ]] && [[ ! -L "$exe" ]]; then
        sed -i '1s|^#!.*\(python[0-9.]*\)|#!/usr/bin/env \1|' "$exe"
    fi
done

# install space-vim
if ! [ -d ~/.space-vim ]; then \
  git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
fi
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "call plug#begin('~/.vim/plugged')" > $PLUGS_VIM
python3 ./plug-parser.py $(find ~/.space-vim/layers -name 'packages.vim') >> $PLUGS_VIM
echo "call plug#end()" >> $PLUGS_VIM
mkdir -p $(dirname $NVIMRC)
[ ! -f $NVIMRC ] && ln -sf $INIT_VIM $NVIMRC
nvim -u $PLUGS_VIM +'PlugInstall' +qall
nvim +'PlugInstall' +qall

# clean up
python3 -m pip uninstall -y lark-parser
rm -f $PLUGS_VIM
rm -f ~/.local/share/nvim/shada/main.shada
rm -f ~/.viminfo
rm -f ~/.fzf.{bash,zsh} ~/{.bashrc,.bash_profile,.bash_history,.zshrc}
rm -rf ~/.cache ~/.LfCache
find ~ -name \*.pyc -delete
go clean -cache -modcache -i -r
