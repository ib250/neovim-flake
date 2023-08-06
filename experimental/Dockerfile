FROM nixos/nix:latest

COPY ./neovim-configured /neovim-configured

RUN nix-channel --update

WORKDIR /tmp

RUN nix-build /neovim-configured
ENV PATH=/tmp/result/bin:$PATH

WORKDIR /scratch
