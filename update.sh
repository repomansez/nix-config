#!/bin/sh
nix flake update
su -c "nixos-rebuild switch --flake .#nixos"
home-manager switch --flake .#mewi@nixos
