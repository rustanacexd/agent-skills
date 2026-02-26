.PHONY: help install-skills uninstall-skills

help:
	@echo "Targets:"
	@echo "  install-skills    Symlink all skills for detected agents"
	@echo "  uninstall-skills  Remove symlinks created from this repo"

install-skills:
	@./install.sh

uninstall-skills:
	@./uninstall.sh
