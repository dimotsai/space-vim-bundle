.PHONY: fetch build release clean

NAME=nvim
VERSION=0.3.8
ARCH ?= x86_64

APPURL=https://github.com/neovim/neovim/releases/download/v$(VERSION)/nvim.appimage
APPIMG=nvim-$(ARCH).AppImage

build: fetch

fetch:
	wget -c $(APPURL) -O $(APPIMG)
	chmod +x $(APPIMG)

release: build

clean:
	rm -f $(APPIMG)
