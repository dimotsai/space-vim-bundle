.PHONY: fetch build release clean

NAME=bear
VERSION=2.4.0
ARCH ?= x86_64

SRCDIR=$(NAME)-$(VERSION)
APPDIR=$(NAME).AppDir
DESKTOP=$(NAME).desktop
ICON=$(NAME).svg
APPRUN=$(NAME).AppRun

build: fetch
	mkdir -p build32 build64
	(cd build32; cmake "../$(SRCDIR)" -DCMAKE_C_COMPILER_ARG1="-m32"; VERBOSE=1 make all;)
	(cd build64; cmake "../$(SRCDIR)" -DCMAKE_C_COMPILER_ARG1="-m64" -DDEFAULT_PRELOAD_FILE='libear.so'; VERBOSE=1 make all;)

fetch:
	if ! [ -d $(SRCDIR) ]; then \
		git clone https://github.com/rizsotto/Bear.git $(SRCDIR); \
	fi
	cd $(SRCDIR) && git checkout $(VERSION) && git submodule update --init;

release: build
	mkdir -p $(APPDIR)
	mkdir -p $(APPDIR)/usr/lib/i386-linux-gnu
	mkdir -p $(APPDIR)/usr/lib/x86_64-linux-gnu
	wget -c https://upload.wikimedia.org/wikipedia/commons/1/11/Bear.svg -O $(ICON)
	install -D -m 0644 build32/libear/libear.so $(APPDIR)/usr/lib32/libear.so
	install -D -m 0644 build64/libear/libear.so $(APPDIR)/usr/lib/libear.so
	install -D -m 0755 build64/bear/bear $(APPDIR)/usr/bin/bear
	install -D -m 644 $(DESKTOP) $(APPDIR)/$(DESKTOP)
	install -D -m 644 $(ICON) $(APPDIR)/$(ICON)
	install -D -m 755 $(APPRUN) $(APPDIR)/AppRun
	ln -sf ../libear.so $(APPDIR)/usr/lib/x86_64-linux-gnu/libear.so
	ln -sf ../../lib32/libear.so $(APPDIR)/usr/lib/i386-linux-gnu/libear.so
	ln -sf lib $(APPDIR)/usr/lib64
	$(APPIMAGETOOL) $(APPDIR)

clean:
	rm -rf $(APPDIR)
	rm -rf $(SRCDIR)
	rm -rf build32
	rm -rf build64
	rm -f $(ICON)
	rm -f $(NAME)-$(ARCH).AppImage
