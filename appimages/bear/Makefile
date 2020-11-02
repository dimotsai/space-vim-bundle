.PHONY: fetch build release clean

NAME=bear
VERSION=2.4.3
ARCH ?= x86_64
DEST ?= install

SRCDIR=$(NAME)-$(VERSION)
APPDIR=$(DEST)/$(NAME)-$(VERSION)
APPRUN=$(NAME).sh

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
	install -D -m 0644 build32/libear/libear.so $(APPDIR)/usr/lib32/libear.so
	install -D -m 0644 build64/libear/libear.so $(APPDIR)/usr/lib/libear.so
	install -D -m 0755 build64/bear/bear $(APPDIR)/usr/bin/bear.py
	install -D -m 755 $(APPRUN) $(APPDIR)/usr/bin/bear
	ln -sf ../libear.so $(APPDIR)/usr/lib/x86_64-linux-gnu/libear.so
	ln -sf ../../lib32/libear.so $(APPDIR)/usr/lib/i386-linux-gnu/libear.so
	ln -sf lib $(APPDIR)/usr/lib64

clean:
	rm -rf $(APPDIR)
	rm -rf $(SRCDIR)
	rm -rf build32
	rm -rf build64
