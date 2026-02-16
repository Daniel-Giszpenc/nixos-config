{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [
        ../../modules/home/hyprland #TODO: conditional module for desktop

        ./packages.nix
        ../../modules/home/bash.nix
        ../../modules/home/git.nix
        ../../modules/home/vscode.nix
    ];

	nixpkgs = {
		config.allowUnfree = true;
        # config.permittedInsecurePackages = [ "electron-25.9.0" ];
	};

    home.username = "iso";
    home.homeDirectory = "/home/iso";

    home.keyboard.layout = "us";

    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
}