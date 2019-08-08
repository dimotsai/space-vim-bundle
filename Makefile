ARCH ?= x86_64
APPIMAGE_DIR = appimages
OUTDIR = output
CURDIR = $(shell pwd)
OUTPATH = $(CURDIR)/$(OUTDIR)

APPSPATH=$(CURDIR)/$(OUTDIR)/apps
APPIMAGETOOL=$(APPSPATH)/appimagetool-x86_64.AppImage
APPIMAGETOOL_URL=https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage

BIN ?= ccls bear nvim python3
BIN_CLEAN = $(addsuffix -clean,$(BIN))
HOMETAR=space-vim.tar.gz
HOMEDIR=../$(OUTDIR)

APPS=$(BIN:%=$(APPSPATH)/%-$(ARCH).AppImage)

.PHONY: all clean test home home-clean $(BIN) $(BIN_CLEAN)

export ARCH
export APPIMAGETOOL
export HOMEDIR
export APPSPATH

all: $(BIN) $(HOMETAR)

clean: $(BIN_CLEAN) $(HOMETAR)-clean $(APPIMAGETOOL)-clean

$(BIN): %: $(APPSPATH)/%-$(ARCH).AppImage

$(BIN_CLEAN): %-clean: $(APPSPATH)/%-$(ARCH).AppImage-clean
	rm -rf $(APPSPATH)
	rm -rf $(OUTDIR)

home: $(HOMETAR)

home-clean: $(HOMETAR)-clean

test: home
	$(MAKE) -C home test

# real targets
#
$(HOMETAR): $(APPS)
	$(MAKE) -C home build
	tar -cf $(HOMETAR) $(OUTDIR)

$(HOMETAR)-clean:
	$(MAKE) -C home clean
	rm -f $(HOMETAR)

$(APPSPATH)/%-$(ARCH).AppImage: $(APPIMAGETOOL)
	$(MAKE) -C $(APPIMAGE_DIR)/$* release DEST=$@

$(APPSPATH)/%-$(ARCH).AppImage-clean:
	$(MAKE) -C $(APPIMAGE_DIR)/$* clean DEST=$(@:%-clean=%)

$(APPIMAGETOOL):
	mkdir -p $(APPSPATH)
	wget -c $(APPIMAGETOOL_URL) -O $(APPIMAGETOOL)
	chmod +x $(APPIMAGETOOL)

$(APPIMAGETOOL)-clean:
	rm -f $(APPIMAGETOOL)
