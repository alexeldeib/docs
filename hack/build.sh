#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

MDBOOK_VER="v0.3.1"

# grab mdbook
# we hardcode linux/amd64 since rust uses a different naming scheme and it's a pain to tran
echo "downloading mdBook-${MDBOOK_VER}-x86_64-unknown-linux-gnu"
set -x
curl -sL -o /tmp/mdbook.tar.gz "https://github.com/rust-lang-nursery/mdBook/releases/download/${MDBOOK_VER}/mdBook-${MDBOOK_VER}-x86_64-unknown-linux-gnu.tar.gz"
tar -C /tmp -xzvf /tmp/mdbook.tar.gz
chmod +x /tmp/mdbook

# Finally build the book.
/tmp/mdbook build
