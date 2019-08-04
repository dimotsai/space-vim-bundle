.PHONY: fetch build release clean

NAME=python3
VERSION=master
ARCH ?= x86_64
DEST ?= $(NAME)-$(ARCH).AppImage

APPURL=https://github.com/niess/linuxdeploy-plugin-python/releases/download/continuous/python3-x86_64.AppImage
APPIMG=$(DEST)

build: fetch

fetch:
	wget -c $(APPURL) -O $(APPIMG)
	chmod +x $(APPIMG)

release: build

clean:
	rm -f $(APPIMG)
