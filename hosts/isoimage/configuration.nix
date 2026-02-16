{ inputs, outputs, lib, config, pkgs, pkgs-stable, modulesPath, ... }:

{
	# no hard-configuration.nix because this will be used by nixos-generator to
	# build an iso which does its own thing to work on a bunch of different hardware
	imports = [
		"${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
		../../modules/core/desktop.nix
	];

	desktop.choice = "hyprland";

	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

		experimental-features = "nix-command flakes";
		# Deduplicate and optimize nix store
		auto-optimise-store = true;
	};

	nixpkgs = {
		config.allowUnfree = true;
        # config.permittedInsecurePackages = [ "electron-25.9.0" ];
	};

	networking.hostName = "iso";
	networking.useDHCP = lib.mkDefault true;
	hardware.enableRedistributableFirmware = true;

	time.timeZone = "America/New_York";

	boot.kernelPackages = pkgs.linuxPackages_6_8;
	boot.supportedFilesystems = [ "ntfs" ];
	boot.tmp.cleanOnBoot = true;

	users.users = {
		iso = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [
							"wheel" "video" "audio" "disk" "networkmanager" 
						];
		};
		tester = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [
							"wheel" "video" "audio" "disk" "networkmanager" 
						];
		};
	};

	# enable sound with pipewire
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

	system.stateVersion = "24.05";
}
