#!/bin/bash

function checkInput {
    echo "press [enter] key to continous ..."
    read input
    if [[ "$input" == "n" ]]; then
      exit
    fi
}

echo "When the step has been error or need to stop"
echo "please press [n] or Ctrl+C to stop it"

nix flake check
checkInput
nixos-rebuild build --flake .#lexon-nixos
checkInput
sudo result/bin/switch-to-configuration test
checkInput
sudo result/bin/switch-to-configuration switch
