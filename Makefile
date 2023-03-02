all: format lint test doc

.PHONY: doc

help:
	@echo "make TARGET"
	@echo
	@echo "TARGETS"
	@echo "    format  format the sources"
	@echo "    lint    lint the sources"
	@echo "    test    run the tests"
	@echo "    doc     create the vim documentation"

format:
	@stylua --config-path=.stylua.toml lua/teaman

lint:
	@luacheck lua/teaman

test:
	nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/plenary/ {minimal_init = 'tests/minimal.vim'}"

doc:
	@lemmy-help ./lua/teaman/*.lua > ./doc/teaman_api.txt

love:
	@echo "not war"

# https://github.com/luarocks/luarocks/wiki/Creating-a-Makefile-that-plays-nice-with-LuaRocks
build: 
	@echo "Do nothing"

install:
	mkdir -p $(INST_LUADIR)
	cp -r autoload plugin queries lua $(INST_LUADIR)
