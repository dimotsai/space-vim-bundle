.PHONY: build clean test

HOMEDIR   ?= output
HOMEPATH   = $(shell realpath $(HOMEDIR))
LOCALDIR   = usr
LOCALPATH  = $(HOMEPATH)/$(LOCALDIR)
APPSPATH  ?= $(shell pwd)/apps
TESTPATH   = $(shell realpath test)

PRODUCTS   = .cache .config .fzf go .LfCache $(LOCALDIR) .space-vim .spacevim .vim
BASH      := $(shell which bash)
ENVRUN    := env - HOME=$(HOMEPATH) LOCALPATH=$(LOCALPATH) $(BASH) --noprofile --norc -l
SHELL     := $(BASH)

build:
	mkdir -p $(LOCALPATH)/bin
	cp template/init.* $(HOMEPATH)
	cp template/install.sh $(HOMEPATH)
	for bin in $(APPSPATH)/*/usr/bin/*; do \
		ln -sf $$(realpath --relative-to=$(LOCALPATH)/bin $$bin) $(LOCALPATH)/bin/$$(basename $$bin); \
	done
	$(ENVRUN) ./build.sh
	for patch in $$(ls patches/*.patch.sh); do \
		$(ENVRUN) $$patch; \
	done
	# make sure every symlink is relative path
	for l in $$(find $(HOMEPATH) -type l); do \
		f=$$(readlink $$l); \
		if [[ "$$f" = /* ]]; then \
			echo "$$f is an absolute path"; exit 1; \
		fi; \
	done


clean:
	if [ -d "$(HOMEPATH)" ]; then \
		chmod -R u+w $(HOMEPATH);\
	fi
	rm -rf $(addprefix $(HOMEPATH)/,$(PRODUCTS))

test:
	mkdir -p $(TESTPATH)
	cp -r $(HOMEPATH) $(TESTPATH)/space-vim-bundle
	env - HOME=$(TESTPATH) TERM=$$TERM bash -l
	rm -rf $(TESTPATH)
