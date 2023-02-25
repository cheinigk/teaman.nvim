all: lint test doc

.PHONY: doc

help:
	@echo "make TARGET"
	@echo
	@echo "TARGETS"
# @echo "    test     run the tests"
	@echo "    lint    lint the sources"
	@echo "    format  format the sources"
	@echo "    doc     create the vim documentation"

lint:
	@luacheck lua/teaman

format:
	@stylua --config-path=.stylua.toml lua/teaman

doc:
	@lemmy-help ./lua/teaman/*.lua > ./doc/teaman_api.txt

love:
	@echo "not war"
