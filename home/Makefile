.PHONY: build clean test

HOMEDIR   ?= output
HOMEPATH   = $(shell realpath $(HOMEDIR))
LOCALDIR   = .local
LOCALPATH  = $(HOMEPATH)/$(LOCALDIR)
APPSPATH  ?= $(shell pwd)/apps

PRODUCTS   = .cache .config .fzf go .LfCache .local .space-vim .spacevim .vim
BASH      := $(shell which bash)
ENVRUN    := env - HOME=$(HOMEPATH) $(BASH) --noprofile --norc -l

build:
	mkdir -p $(LOCALPATH)/bin
	cp template/.spacevim $(HOMEPATH)/.spacevim
	for bin in $(APPSPATH)/*; do \
		ln -sf $$(realpath --relative-to=$(LOCALPATH)/bin $$bin) $(LOCALPATH)/bin/$$(basename $${bin%%-$(ARCH).AppImage}); \
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
	env - HOME=$(HOMEPATH) TERM=$$TERM PATH=$(HOMEPATH)/.local/bin:$$PATH bash -l
