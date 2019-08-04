.PHONY: build clean

HOMEDIR   ?= output
HOMEPATH   = $(shell pwd)/$(HOMEDIR)
LOCALDIR   = .local
LOCALPATH  = $(HOMEPATH)/$(LOCALDIR)
APPSPATH  ?= $(shell pwd)/apps

PRODUCTS   = .cache .config .fzf go .LfCache .local .space-vim .spacevim .vim

build:
	mkdir -p $(LOCALPATH)/bin
	cp template/.spacevim $(HOMEPATH)/.spacevim
	for bin in $(APPSPATH)/*; do ln -sf $$bin $(LOCALPATH)/bin/$$(basename $${bin%%-$(ARCH).AppImage}); done
	export HOME=$(HOMEPATH); \
	export PATH=$(LOCALPATH)/bin:$$PATH; \
	./build.sh

clean:
	if [ -d "$(HOMEPATH)" ]; then \
		chmod -R u+w $(HOMEPATH);\
	fi
	rm -rf $(addprefix $(HOMEPATH)/,$(PRODUCTS))
