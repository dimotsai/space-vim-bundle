#!/usr/bin/env bash
set -ex

export PATH=$LOCALPATH/bin:$PATH
export PYTHONUSERBASE=$LOCALPATH
export XDG_DATA_HOME=$LOCALPATH/share

PLUGS_VIM=~/plugs.vim

function pip_install()
{
  local package=$1
  python3 -m pip install --user $package
  # --install-option="--install-scripts=$LOCALPATH/bin"
}

# install python dependecies
pip_install pynvim
pip_install python-language-server[all]
pip_install lark-parser
# fix shebangs of python scripts
for exe in $(ls "$LOCALPATH/bin/"*); do
    if [[ -f "$exe" ]] && [[ -x "$exe" ]] && [[ ! -L "$exe" ]]; then
        sed -i '1s|^#!.*\(python[0-9.]*\)|#!/usr/bin/env \1|' "$exe"
    fi
done

# install space-vim
if ! [ -d ~/space-vim ]; then \
  git clone https://github.com/liuchengxu/space-vim.git ~/space-vim
fi
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "call plug#begin('~/vim/plugged')" > $PLUGS_VIM
python3 ./plug-parser.py $(find ~/space-vim/layers -name 'packages.vim') >> $PLUGS_VIM
cat ./extra.vim >> $PLUGS_VIM
echo "call plug#end()" >> $PLUGS_VIM
nvim -u $PLUGS_VIM +'set nomore' +'PlugInstall' +qall

# clean up
python3 -m pip uninstall -y lark-parser
rm -f $PLUGS_VIM
rm -f $XDG_DATA_HOME/nvim/shada/main.shada
rm -f ~/.viminfo
rm -f ~/.fzf.{bash,zsh} ~/{.bashrc,.bash_profile,.bash_history,.zshrc}
rm -rf ~/.cache ~/.LfCache
find ~ -name \*.pyc -delete
go clean -cache -modcache -i -r
