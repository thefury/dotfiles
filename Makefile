SHELL=bash

.PHONY: all
all: bin dotfiles

.PHONY: bin
bin:
	for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sf $$file $${HOME}/bin/$$f; \
	done

.PHONY: dotfiles
dotfiles:
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $${HOME}/$$f; \
	done;\
	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;

