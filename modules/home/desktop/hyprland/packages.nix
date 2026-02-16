{ config, options, lib, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.desktop.hyprland.default-pkgs;
in
{
    # option exists because importing hyprland to check if enabled would be a recursive import issue
    options.home-modules.desktop.hyprland.default-pkgs = with types; {
        install = mkEnableOption "Whether to setup hyprland with associated packages and config on this desktop.";
    };

    config = mkIf cfg.install {
        home.packages = with pkgs; [
            adwaita-icon-theme

            wlr-randr
            xorg.xrandr    # for XWayland windows
            nwg-look

            swww           # wallpaper daemon
            hyprcursor

            
            brightnessctl
            wl-screenrec

            wl-clipboard
            xdg-utils
            copyq

            grim
            slurp
            swappy
            imagemagick

            pulseaudio
            killall # Restart processes
            pavucontrol # Audio panel
            sway-contrib.grimshot # Screenshots

            # notifications
            mako
            libnotify
        ];

        programs.rofi = {
            enable = true;
            package = pkgs.rofi;
            plugins = [
                pkgs.rofi-emoji
            ];
            font = "cascadia-code";
            location = "center";
        };
    };
}