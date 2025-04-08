#!/usr/bin/env bash

main() {
    get_api_gateway_url
}

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/___run_main.sh"
