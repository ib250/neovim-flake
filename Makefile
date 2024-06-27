
lock:
	nix flake lock
	nix flake show

develop:
	nix develop

update:
	nix flake update

format:
	nix fmt

sync: format
	git commit -am "sync"
	git push

build:
	nix build

.phony: lock develop update format sync build
