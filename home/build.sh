#!/usr/bin/env bash
set -ex

export PATH=$LOCALPATH/bin:$PATH
export PYTHONUSERBASE=$LOCALPATH
export XDG_DATA_HOME=$LOCALPATH/share

PLUGS_VIM=~/plugs.vim

function pip_install()
{
  local package=$1
  python3 -m pip install $package
}

# install python dependecies
pip_install pynvim
pip_install python-language-server[all]

# install space-vim
if ! [ -d ~/space-vim ]; then \
  git clone https://github.com/liuchengxu/space-vim.git ~/space-vim
fi
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "let g:plug_shallow = 0" > $PLUGS_VIM
echo "call plug#begin('~/vim/plugged')" >> $PLUGS_VIM
python3 ./layers.py ~/space-vim $PLUGS_VIM
cat ./extra.vim >> $PLUGS_VIM
echo "call plug#end()" >> $PLUGS_VIM
nvim -u $PLUGS_VIM +'set nomore' +'PlugInstall' +qall

# download fzf
if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
fi

(cd ~/.fzf; ./install --all)

#rm -f $PLUGS_VIM
rm -f $XDG_DATA_HOME/nvim/shada/main.shada
rm -f ~/.viminfo
rm -f ~/.fzf.{bash,zsh} ~/{.bashrc,.bash_profile,.bash_history,.zshrc}
rm -rf ~/.cache ~/.LfCache
find ~ -name \*.pyc -delete
