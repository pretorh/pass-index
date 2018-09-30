all: test

clean:
	rm -rf tests/.gpg

install-local:
	install -v bin/index.bash ~/.password-store/.extensions/

test: tests/.gpg
	@prove tests/*.sh

tests/.gpg:
	sh ./tests/setup/init-test-gpg.sh ./tests/.gpg
