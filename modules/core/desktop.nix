{ inputs, lib, config, options, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.system-modules.desktop;
in
{
    options.system-modules.desktop = with types; {
        kde = mkOption {
            type = bool;
            default = true;
            description = "Enable kde desktop environment with associated packages and config.";
        };
        hyprland = mkOption {
            type = bool;
            default = true;
            description = "Enable hyprland with associated packages and config.";
        };
        sddm = mkOption {
            type = bool;
            default = true;
            description = "Enable sddm.";
        };
    };

	config = mkMerge [
		({
			services.xserver.enable = true;
			services.xserver.videoDrivers = [ "amdgpu" ];

			environment.systemPackages = [
				pkgs.kdePackages.qtwayland
			];

            environment.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";
		})

		( mkIf (cfg.sddm)
		{
			services.displayManager.sddm.enable = true;
			services.displayManager.sddm.wayland.enable = true;
		})

		( mkIf (cfg.kde)
		{
			services.desktopManager.plasma6.enable = true;
			programs.dconf.enable = true;
		})

		( mkIf (cfg.hyprland)
		{
			services.displayManager.sddm.wayland.enable = true;			

			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
				package = pkgs.hyprland;
				portalPackage = pkgs.xdg-desktop-portal-hyprland;
				withUWSM = true;
			};

			services.dbus.enable = true;
			xdg.portal = {
				enable = true;
				wlr.enable = false;
				# extraPortals breaks laptop config
				extraPortals = with pkgs; [
					kdePackages.xdg-desktop-portal-kde
					xdg-desktop-portal-hyprland
				];
				xdgOpenUsePortal = true;
			};
		})
	];
}
