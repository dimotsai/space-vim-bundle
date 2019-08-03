.PHONY: all

ARCH ?= x86_64
APPIMAGE_DIR = appimages
OUTDIR = Applications
CURDIR = $(shell pwd)

APPIMAGETOOL=$(CURDIR)/$(OUTDIR)/appimagetool-x86_64.AppImage
APPIMAGETOOL_URL=https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage

BIN ?= ccls bear nvim python3
HOMES ?= nvim
HOMETAR=space-vim.tar.gz

export ARCH
export APPIMAGETOOL
export HOMETAR

all: $(BIN) $(HOMETAR)

clean: $(addsuffix -$(ARCH).AppImage-clean,$(BIN)) $(HOMETAR)-clean
	rm -f $(APPIMAGETOOL)

$(BIN): %: %-$(ARCH).AppImage

$(HOMETAR):
	$(MAKE) -C home release

$(HOMETAR)-clean:
	$(MAKE) -C home clean

%-$(ARCH).AppImage-clean:
	$(MAKE) -C $(APPIMAGE_DIR)/$* clean

%-$(ARCH).AppImage: $(APPIMAGETOOL)
	$(MAKE) -C $(APPIMAGE_DIR)/$* release
	install -D -m 755 $(APPIMAGE_DIR)/$*/$@ $(OUTDIR)/$@

%-$(ARCH).AppImage.home.tar.gz:
	echo

%-$(ARCH).AppImage.home.tar.gz-clean:
	echo

$(APPIMAGETOOL):
	mkdir -p $(OUTDIR)
	wget -c $(APPIMAGETOOL_URL) -O $(APPIMAGETOOL)
	chmod +x $(APPIMAGETOOL)

