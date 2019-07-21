.PHONY: fetch build release clean

NAME=nvim
VERSION=master
ARCH ?= x86_64

APPURL=https://github.com/niess/linuxdeploy-plugin-python/releases/download/continuous/python3-x86_64.AppImage
APPIMG=python3-$(ARCH).AppImage

build: fetch

fetch:
	wget -c $(APPURL) -O $(APPIMG)
	chmod +x $(APPIMG)

release: build

clean:
	rm -f $(APPIMG)
