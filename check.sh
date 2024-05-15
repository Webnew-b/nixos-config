#!/bin/bash

function checkInput {
    echo "continous..."
    read input
    if [[ "$input" == "n" ]]; then
      exit
    fi
}

nix flake check
checkInput
nixos-rebuild build --flake .#lexon-nixos
checkInput
sudo result/bin/switch-to-configuration test
checkInput
sudo result/bin/switch-to-configuration switch
