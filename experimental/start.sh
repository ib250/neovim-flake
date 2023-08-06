#!/usr/bin/env bash

docker buildx build -t nvim-scratch .
docker run \
  -it --rm \
  -v "$(pwd)/neovim-user":/neovim-user \
  -v "$(pwd)/prj":/scratch \
  --workdir /scratch \
  nvim-scratch nix-shell --impure
