#!/usr/bin/env bash

main() {
    aws sts get-caller-identity
}

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/___run_main.sh"
