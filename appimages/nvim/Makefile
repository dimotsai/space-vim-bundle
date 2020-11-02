.PHONY: fetch build release clean

NAME=nvim
VERSION=0.4.4
ARCH ?= x86_64
DEST ?= install

APPURL=https://github.com/neovim/neovim/releases/download/v$(VERSION)/nvim.appimage
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
	rm -f $(APPDIR)/nvim.desktop
	rm -f $(APPDIR)/nvim.png

clean:
	rm -f $(APPIMG)
	rm -rf $(APPDIR)
	rm -rf squashfs-root
