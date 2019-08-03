.PHONY: build release clean

HOMEDIR=output
HOMEPATH=$(shell pwd)/$(HOMEDIR)
HOMETAR ?= space-vim.tar.gz
LOCALDIR=.local
LOCALPATH=$(HOMEPATH)/$(LOCALDIR)
APPSPATH ?= $(shell pwd)/../Applications

build:
	mkdir -p $(LOCALPATH)/bin
	for bin in $(APPSPATH)/*; do ln -sf $$bin $(LOCALPATH)/bin/$$(basename $${bin%%-$(ARCH).AppImage}); done
	export HOME=$(HOMEPATH); \
	export PATH=$(LOCALPATH)/bin:$$PATH; \
	./build.sh
	rm -f $(HOMEPATH)/.fzf.{bash,zsh} $(HOMEPATH)/{.bashrc,.zshrc}
	rm -f $(HOMEPATH)/.local/bin/*

release: build
	tar -cf $(HOMETAR) $(HOMEDIR)

clean:
	chmod -R u+w $(HOMEPATH)
	rm -rf $(HOMEPATH)
	rm -f $(HOMETAR)
