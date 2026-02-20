{ inputs, lib, config, options, pkgs, pkgs-stable, ... }:

{
    imports = [
        ./virtualization.nix
        ./desktop.nix
        ./yubikey.nix
        ./sops.nix
        ./tailscale.nix
        ./wireshark.nix
        ./signal.nix
    ];
}