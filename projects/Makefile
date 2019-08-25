%:
	@:

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

build:
	../bin/zilf $(call args, "template").zil && ../bin/zapf $(call args, "template").zap

play:
	open $(call args, "template").z3

clean:
	rm -f *.z?
	rm -f *.zap
