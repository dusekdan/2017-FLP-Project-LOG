# FLP2017-LOG, Maticové operace, xdusek21, Daniel Dušek

all:
	swipl -g main -q -o flp17-log -c flp17-log.pl

run-tests: all
	@echo ========Test01========
	@./flp17-log < tests/test.1.in
	@echo ========Test02========
	@./flp17-log < tests/test.2.in
	@echo ========Test03========
	@./flp17-log < tests/test.3.in
	@echo ========Test04========
	@./flp17-log < tests/test.4.in

clean:
	rm flp17-log

wis-pack:
	zip "flp-log-xdusek21.zip" flp17-log.pl README.md tests/* Makefile
