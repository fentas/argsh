:rocket: WORK IN PROGRESS

---

# argsh
[![Latest release](https://img.shields.io/github/release/fentas/argsh.svg)](https://github.com/fentas/argsh/releases/latest)
[![npm package](https://img.shields.io/npm/v/argsh.svg)](https://www.npmjs.com/package/argsh)
[![License](https://img.shields.io/github/license/fentas/argsh.svg)](https://github.com/fentas/argsh/blob/master/LICENSE)
[![Continuous integration status for Linux and macOS](https://img.shields.io/travis/fentas/argsh/master.svg?label=travis%20build)](https://travis-ci.org/fentas/argsh)

Create simple and short shell (bash) scripts with ease. `argsh` takes away the
tedious work to create your own argument parser and keeps your shell usage at bay.

## Install argsh
* to be able to use argsh scripts on your system, it makes sense to install it globally
```sh
# manually
git clone https://github.com/fentas/argsh.git
cd argsh/bin
suod ln -sf argsh /usr/local/bin
```

## Quick start
* Describe your arguments and `argsh` does the rest.

### script template
```sh
touch <your-script-name>
sudo chmod +x <your-script-name>
```

### create argsh script from template
```sh
#!/usr/bin/env argsh
set -eu -o pipefail

# --- OPTIONS
# argsh(t|test-option): env(TEST_OPTION) def(false) des(A test option.) val()

# --- ACTIONS
# argsh(T|test-action):   des(A test action.)

# --- ACTIONS

# --- PATHS
: "${PATH_BASE:="$(git rev-parse --show-toplevel)"}"

# --- VARIABLES

# --- IMPORTS

# --- MAIN
main() {
  # dependencies

  # actions
  for ACTION in ${ARGSH_ACTIONS}; do case "${ACTION}" in
    T|test-action)  test_action ;;
  esac; done
}

# --- FUNCTIONS
test_action() {
  echo "$TEST_OPTION"
}

# --- VALIDATORS

# --- RUN
[[ "${0}" != "${BASH_SOURCE[0]}" ]] || main "${@}"
```

## Include `argsh` into your tests

Follow up.

## Honorable Mentions

Folder structure is right out copied from https://github.com/bats-core/bats-core. Also is bats used for testing. Big thanks for that.
