{ inputs, outputs, lib, config, pkgs, rootPath, ... }:

{
	imports = [
		../../modules/core/desktop.nix
		./hardware-configuration.nix

		../../modules/roles/workstation/system-modules.nix
	];

    roles.workstation.system = {
        enable = true;
        hostname = "stardom";
    };

	users.users = {
		nero = {
			isNormalUser = true;
			hashedPasswordFile = config.sops.secrets."nero-user-password".path;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" "libvirtd" ];
		};
		bo = {
			initialPassword = "nixisreallycool";
			isNormalUser = true;
			extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "users" ];
		};
	};

	# programs.uwsm = {
	# 	enable = true;
	# 	waylandCompositors."hyprland" = {
	# 		prettyName = "Hyprland";
	# 		comment = "Hyprland compositor managed by UWSM";
	# 		binPath = "/run/current-system/sw/bin/Hyprland";
	# 	};
	# };

	programs.zsh.enable = true;
	users.users.nero.shell = pkgs.zsh;

	users.groups."realtime".members = [ "nero" ];

	networking.networkmanager.enable = true;

	services.printing.enable = true;
	boot.tmp.cleanOnBoot = true;

	security.polkit.enable = true;

	# enables unpatched dynamic binaries to run on NixOS, required for C# Dev Kit ext
	# programs.nix-ld.enable = true;

	# enable when needed with a nix switch: not on always for security
	# keeping for apps not made into a nix pkg provided this way
	# currently: balenaEtcher
	# programs.appimage = {
	# 	enable = true;
	# 	binfmt = true;
	# };

	# allow let's encrypt staging certs as trusted (for testing)
	# security.pki.certificateFiles = [
	# 	"${rootPath}/hosts/stardom/letsencrypt-stg-root-x1.pem"
	# ];

	# gparted has to be installed in system config it seems
	#TODO: move gparted install into system-module
	environment.systemPackages = [
		pkgs.nix-tree
		pkgs.gparted
		pkgs.wine-wayland
		pkgs.winetricks
		pkgs.yabridge
		pkgs.yabridgectl
		pkgs.gamemode

        # pkgs.davinci-resolve # to test if works here in sys pkgs in future
        pkgs.audacity
	];

	users.groups."gamemode".members = [ "nero" ];
	programs.gamemode = {
		enable = true;
		enableRenice = true;
		settings = {
			general = {
				softrealtime = "on";
				desiredgov = "performance";
				renice = 11;
				disable_splitlock = 1;
				pin_cores= "yes";
				inhibit_screensaver = 0;
			};
			custom = {
				start = "notify-send -a 'Gamemode' 'Optimizations activated'";
				end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
			};
		};
	};
}
