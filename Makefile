PREFIX=/usr
LIBDIR="$(PREFIX)/lib"

all: test

install:
	install -v bin/index.bash $(LIBDIR)/password-store/extensions

clean:
	rm -rf tests/.gpg

local-install:
	install -v bin/index.bash ~/.password-store/.extensions/

check: lint test

lint:
	@shellcheck --format gcc bin/index.bash tests/*.sh tests/setup/*.sh
	@echo "lint ok"

test: tests/.gpg
	@prove --directives tests/*.sh

tests/.gpg:
	sh ./tests/setup/init-test-gpg.sh ./tests/.gpg
