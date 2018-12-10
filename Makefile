SHELL=/bin/bash
SCRIPTS=./scripts

all: run

run:
	@${SCRIPTS}/run.sh

.PHONY : test
test:
	@echo hello
