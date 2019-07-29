%:
	@:

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

build:
	mono ../bin/zilf.exe $(call args, "template").zil && mono ../bin/zapf.exe $(call args, "template").zap

play:
	open $(call args, "template").z3

clean:
	rm -f *.z3 *.z4 *.z5 *.z6 *.z8
	rm -f *.zap
