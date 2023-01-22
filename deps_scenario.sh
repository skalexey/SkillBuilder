#!/bin/bash

function deps_scenario()
{
    local THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source $THIS_DIR/dependencies.sh
    source $THIS_DIR/deps_config.sh
}

deps_scenario $@
