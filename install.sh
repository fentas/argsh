
#!/usr/bin/env bash

set -e

ARGSH_ROOT="${0%/*}"
PREFIX="$1"

if [[ -z "$PREFIX" ]]; then
  printf '%s\n' \
    "usage: $0 <prefix>" \
    "  e.g. $0 /usr/local" >&2
  exit 1
fi

install -d -m 755 "$PREFIX"/{bin,libexec/argsh,share/man/man{1,7}}
install -m 755 "$ARGSH_ROOT/bin"/* "$PREFIX/bin"
install -m 755 "$ARGSH_ROOT/libexec/argsh"/* "$PREFIX/libexec/argsh"

echo "Installed Bats to $PREFIX/bin/argsh"