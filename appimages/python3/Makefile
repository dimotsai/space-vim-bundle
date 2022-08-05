.PHONY: fetch build release clean

NAME=python
VERSION=3.9.13
ARCH ?= x86_64
DEST ?= install

APPURL=https://github.com/niess/python-appimage/releases/download/python3.9/python$(VERSION)-cp39-cp39-manylinux2014_$(ARCH).AppImage
APPIMG=$(NAME)-$(ARCH).AppImage
APPDIR=$(DEST)/$(NAME)-$(VERSION)

build: fetch
	./$(APPIMG) --appimage-extract

fetch:
	wget -c $(APPURL) -O $(APPIMG)
	chmod +x $(APPIMG)

release: build
	mkdir -p $(APPDIR)
	cp -r squashfs-root/* $(APPDIR)
	rm -f $(APPDIR)/AppRun
	rm -f $(APPDIR)/python$(VERSION).desktop
	rm -f $(APPDIR)/python.png

clean:
	rm -f $(APPIMG)
	rm -rf $(APPDIR)
	rm -rf squashfs-root
