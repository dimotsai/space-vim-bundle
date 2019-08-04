.PHONY: fetch build release clean

NAME=ccls
VERSION=0.20190314.1
ARCH ?= x86_64
SHELL:=/bin/bash
DEST ?= $(NAME)-$(ARCH).AppImage

getdep = $(shell ldd $(1) | grep $(2) | awk '{ print $$3 }')

SRCDIR=$(NAME)-$(VERSION)
APPDIR=$(NAME).AppDir
DESKTOP=$(NAME).desktop
ICON=$(NAME).png

build: fetch
	wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
	if ! [ -d clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 ]; then \
	    tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz; \
	fi
	cmake -H$(SRCDIR) -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$(shell pwd)/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04
	cmake --build Release

fetch:
	if ! [ -d $(SRCDIR) ]; then \
		git clone https://github.com/MaskRay/ccls.git $(SRCDIR); \
	fi
	cd $(SRCDIR) && git checkout $(VERSION) && git submodule update --init;

release: build
	mkdir -p $(APPDIR)
	mkdir -p $(APPDIR)/usr/bin
	mkdir -p $(APPDIR)/usr/lib
	wget -c https://img.icons8.com/color/96/000000/c-plus-plus.png -O $(ICON)
	install -D -m 644 $(DESKTOP) $(APPDIR)/$(DESKTOP)
	install -D -m 644 $(ICON) $(APPDIR)/$(ICON)
	install -D -m 755 Release/ccls $(APPDIR)/usr/bin/ccls
	install -D -m 644 $(call getdep,Release/ccls,libstdc++.so) $(APPDIR)/usr/lib
	install -D -m 644 $(call getdep,Release/ccls,libncursesw.so) $(call getdep,Release/ccls,libtinfo.so) $(APPDIR)/usr/lib
	install -D -m 644 $(call getdep,Release/ccls,libgcc_s.so) $(APPDIR)/usr/lib
	patchelf --force-rpath --set-rpath '$$ORIGIN/../lib' $(APPDIR)/usr/bin/ccls
	for lib in $(APPDIR)/usr/lib/*; do patchelf --set-rpath '$$ORIGIN' $$lib; done
	ln -sf usr/bin/ccls $(APPDIR)/AppRun
	$(APPIMAGETOOL) $(APPDIR) $(DEST)

clean:
	rm -rf $(APPDIR)
	rm -rf $(SRCDIR)
	rm -rf Release
	rm -rf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04
	rm -f $(ICON)
	rm -f clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
	rm -f $(NAME)-$(ARCH).AppImage
	rm -f $(DEST)

