all: lint test doc

.PHONY: doc

help:
	echo "make TARGET"
	echo "TARGETS"
	# echo "\t test \t run the tests"
	echo "\t lint \t lint the sources"
	echo "\t doc  \t create the vim documentation"

lint:
	luacheck lua/teaman

doc:
	lemmy-help ./lua/teaman/*.lua > ./doc/teaman.txt

love:
	echo "not war"
