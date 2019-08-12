#!/usr/bin/env bash

BUNDLE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

backup() {
  if [ -e "$1" ]; then
    echo
    echo -e "\\033[1;34m==>\\033[0m Attempting to back up your $1"
    today=$(date +%Y%m%d_%s)
    mv -v "$1" "$1.$today"

    ret="$?"
    echo -e "Your $1 has been backed up"
  fi
}

make_link() {
  local dst=$2
  local src=$1
  if ! [[ "$src" -ef "$dst" ]]; then
    mkdir -p $(dirname "$dst")
    backup $dst
    ln -sf $src $dst
    echo -e "symlink $dst -> $src"
  fi
}

copy_file() {
  local dst=$2
  local src=$1
  if ! [[ "$src" -ef "$dst" ]]; then
    mkdir -p $(dirname "$dst")
    backup $dst
    cp -r $src $dst
    echo -e "install $dst"
  fi
}

# install python packages
mkdir -p $HOME/.local/lib/python3.7/site-packages
echo "$BUNDLE/usr/lib/python3.7/site-packages" > $HOME/.local/lib/python3.7/site-packages/space-vim-bundle.pth

# install vim-plug
copy_file $BUNDLE/usr/share/nvim/autoload/plug.vim ~/.local/share/site/nvim/autoload/plug.vim

# install .fzf
make_link $BUNDLE/.fzf ~/.fzf

# install .space-vim
make_link $BUNDLE/space-vim ~/.space-vim

# install init.vim
make_link $BUNDLE/space-vim/init.vim ~/.config/nvim/init.vim

# install .spacevim
if ! [[ -f ~/.spacevim ]]; then
  copy_file $BUNDLE/space-vim/init.spacevim ~/.spacevim
fi
# patch plug home patch
sed -i -E "s|(let\s+g:spacevim_plug_home\s*=\s*)(.*)|\" $(date +%Y%m%d_%s):\2\n\1'$BUNDLE/vim/plugged'|" ~/.spacevim
echo -e "patched ~/.spacevim"
