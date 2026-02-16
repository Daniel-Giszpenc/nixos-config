{ inputs, options, config, lib, pkgs, pkgs-stable, rootPath, virtualDesktopsPatched, ... }:

with lib;
let
    cfg = config.home-modules.desktop.hyprland.virt-desktops;
    virtualDesktopSwitchExe = "${rootPath}/pkgs/virt-desktop-switcher/desktop-switcher";
in
{
    options.home-modules.desktop.hyprland.virt-desktops = with types; {
        enable = mkEnableOption "Whether to setup virt-desktops with associated exes and config on this desktop.";
    };

    config = mkIf cfg.enable {
        wayland.windowManager.hyprland = {
            plugins = [
                inputs.hyprland-virtual-desktops.packages.${pkgs.system}.virtual-desktops
            ];

            # hyprlang config
            extraConfig = lib.concatStrings [
                ''
                    plugin {
                        virtual-desktops {
                            cycleworkspaces = 1
                            rememberlayout = size
                            notifyinit = 0
                            verbose_logging = 0
                        }
                    }
                ''
            ];

            settings = {
                bind = [
                    "SUPER, Q, exec, ${virtualDesktopSwitchExe} focus activityRofi"
                    "ALT, R, exec, ${virtualDesktopSwitchExe} window activityRofi"
                    
                    "CTRL ALT, up, exec, ${virtualDesktopSwitchExe} focus up"
                    "CTRL ALT, down, exec, ${virtualDesktopSwitchExe} focus down"
                    "CTRL ALT, right, exec, ${virtualDesktopSwitchExe} focus right"
                    "CTRL ALT, left, exec, ${virtualDesktopSwitchExe} focus left"

                    "CTRL $mainMod, up, exec, ${virtualDesktopSwitchExe} window up"
                    "CTRL $mainMod, down, exec, ${virtualDesktopSwitchExe} window down"
                    "CTRL $mainMod, right, exec, ${virtualDesktopSwitchExe} window right"
                    "CTRL $mainMod, left, exec, ${virtualDesktopSwitchExe} window left"
                ];
            };

        };
    };
}