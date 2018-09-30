TEST_FILES=$(wildcard tests/*.sh)
TESTS=$(TEST_FILES:.sh=)

all: test

clean:
	rm -rf tests/.gpg

install-local:
	install -v bin/index.bash ~/.password-store/.extensions/

test: $(TESTS)

tests/%: tests/.gpg
	@echo "=== $@ ==="
	@sh $@.sh

tests/.gpg:
	sh ./tests/setup/init-test-gpg.sh ./tests/.gpg
