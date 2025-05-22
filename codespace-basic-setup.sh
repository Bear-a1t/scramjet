#!/bin/bash

set -e

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

. "$HOME/.cargo/env"

mkdir -p ~/.local/bin ~/.local/lib

pnpm install

cargo install wasm-bindgen-cli

VER=$(curl -sI https://github.com/WebAssembly/binaryen/releases/latest | awk -F '/' '/^location:/ {print substr($NF, 1, length($NF)-1)}')
curl -LO "https://github.com/WebAssembly/binaryen/releases/download/$VER/binaryen-${VER}-x86_64-linux.tar.gz"
tar xvf "binaryen-${VER}-x86_64-linux.tar.gz"
rm "binaryen-${VER}-x86_64-linux.tar.gz"
mv "binaryen-${VER}/bin/"* ~/.local/bin/
mv "binaryen-${VER}/lib/"* ~/.local/lib/
rm -rf "binaryen-${VER}"

cargo install --git https://github.com/r58playz/wasm-snip

pnpm rewriter:build
pnpm build
