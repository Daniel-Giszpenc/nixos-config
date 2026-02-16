{ inputs, lib, config, pkgs, pkgs-stable, plasma-manager, rootPath, ... }:

{
    imports = [ ../../../../modules/roles/workstation/home-modules.nix ];

    home.keyboard.layout = "us";

    roles.workstation.home = {
        enable = true;
        user = "nero";
    };

	home-modules.desktop = {
		kde.enable = true;
		hyprland = {
			enable = false; # hyprland-virtual-desktops currently broken due to header inclusion failure 1-19-26
			hyprlock = {
				enable = true;
				wallpaper = "/home/nero/Pictures/Wallpapers/bench.jpg";
				profile = "/home/nero/Pictures/Icons/neroProfile.png";
			};
			hypridle.enable = true;
			# main PC
			# FIXME: move to stardom users and create for starfief
			# monitors = [
			# 	"DP-2, 3440x1440@100, auto-left, 1"
			# 	"HDMI-A-1, 1680x1050@60, 0x0, 1, transform, 1"
			# ];
			monitors = [
				"DP-2, 3440x1440@100, 0x0, 1"
				"HDMI-A-1, 1680x1050@60, auto-left, 1, transform, 1"
			];
			default-pkgs.install = true;
			waybar = {
				enable = true;
				output-monitor = "HDMI-A-1";
				virt-desktops-modules.enable = true;
				c-modules = [ "custom/weather" "custom/activity" "group/group-virt-desktops" ];
				# c-modules = [ "custom/weather" ];
				height = 30;
			};
			virt-desktops.enable = true;
			hyprkool.enable = false;
		};
	};

	home.file.".local/lib/wireshark/extcap/cshargextcap" = {
		source = "${rootPath}/pkgs/external/wireshark-plugins/cshargextcap";
		executable = true;
	};
	home.file.".local/lib/wireshark/plugins/ts-dissector.lua" = {
		source = "${rootPath}/pkgs/external/wireshark-plugins/ts-dissector.lua";
	};

	home.packages = [
		# creative video
		pkgs.handbrake
		# pkgs-stable.avidemux
		# creative audio
		pkgs.lmms
		pkgs.ardour
		pkgs.reaper
		pkgs.helio-workstation
		# wine
		pkgs.bottles
		# IT
		pkgs.terraform
		pkgs.go
		pkgs.ansible
		# vpn
		pkgs.protonvpn-gui
		# more
	];
}
