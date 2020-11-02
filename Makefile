ARCH ?= x86_64
APPIMAGE_DIR = appimages
OUTDIR = space-vim-bundle
CURDIR = $(shell pwd)
OUTPATH = $(CURDIR)/$(OUTDIR)

APPSPATH=$(CURDIR)/$(OUTDIR)/apps

BIN ?= ccls bear nvim python3
BIN_CLEAN = $(addsuffix -clean,$(BIN))
HOMETAR=space-vim-bundle.tar.gz
HOMEDIR=../$(OUTDIR)

APPS=$(BIN:%=$(APPSPATH)/%-$(ARCH).AppImage)

.PHONY: all clean test home home-clean $(BIN) $(BIN_CLEAN)

export ARCH
export HOMEDIR
export APPSPATH

all: $(BIN) $(HOMETAR)

clean: $(BIN_CLEAN) $(HOMETAR)-clean

$(BIN): %:
	$(MAKE) -C $(APPIMAGE_DIR)/$@ release DEST=$(APPSPATH)

$(BIN_CLEAN): %-clean:
	$(MAKE) -C $(APPIMAGE_DIR)/$(@:%-clean=%) clean DEST=$(@:%-clean=%)
	rm -rf $(APPSPATH)
	rm -rf $(OUTDIR)

home: $(HOMETAR)

home-clean: $(HOMETAR)-clean

test: home
	$(MAKE) -C home test

# real targets
#
$(HOMETAR):
	$(MAKE) -C home build
	tar -cf $(HOMETAR) $(OUTDIR)

$(HOMETAR)-clean:
	$(MAKE) -C home clean
	rm -f $(HOMETAR)