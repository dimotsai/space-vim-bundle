.PHONY: build

HOMEDIR=$(shell pwd)/build
LOCALDIR=$(HOMEDIR)/.local
APPSDIR ?= $(shell pwd)/../Applications

INIT_VIM      := ../../.space-vim/init.vim
VIMRC         := ~/.vimrc
NVIMRC        := ~/.config/nvim/init.vim

build:
	mkdir -p $(LOCALDIR)/bin
	for bin in $(APPSDIR)/*; do ln -sf $$bin $(LOCALDIR)/bin/$$(basename $${bin%%-$(ARCH).AppImage}); done
	export HOME=$(HOMEDIR); \
	export PATH=$(LOCALDIR)/bin:$$PATH; \
	python3 -m pip install --user pynvim; \
	if ! [ -d ~/.space-vim ]; then \
		git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim; \
	fi; \
	cd ~/.space-vim; \
	cp ../../template/.spacevim ~/.spacevim; \
	mkdir -p ~/.config/nvim; \
	[ ! -f $(NVIMRC) ]       && ln -sf $(INIT_VIM) $(NVIMRC)        && echo "    - Created $(NVIMRC)"; \
	nvim +'PlugInstall' +qall; \
	rm -f $(HOMEDIR)/.fzf.{bash,zsh} $(HOMEDIR)/{.bashrc,.zshrc}
	rm -f $(HOMEDIR)/.local/bin/*

release: build
	tar -cf home.tar.gz build

clean:
	rm -rf $(HOMEDIR)
	rm -f home.tar.gz
