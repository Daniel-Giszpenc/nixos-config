{ options, config, lib, plasma-manager, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.desktop.kde;
in
{
    options.home-modules.desktop.kde = with types; {
        enable = mkEnableOption "Enable kde desktop environment with associated packages and config.";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            flameshot
            kdePackages.yakuake
            kdePackages.sddm-kcm
            wayland-utils # Wayland utilities
            wl-clipboard # Command-line copy/paste utilities for Wayland

            kdePackages.krohnkite # Tiling software
        ];

        programs.plasma = {
            enable = true;

            workspace = {
                clickItemTo = "select";
                lookAndFeel = "org.kde.breezedark.desktop";
                #   cursorTheme = "Bibata-Modern-Ice";
                #   iconTheme = "Papirus-Dark";

                # note no longer using Qt5
                #   wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
            };


            shortcuts = {
                kwin = {
                    #TODO: add shortcuts for moving windows
                    "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
                    "Switch One Desktop to the Right" = "Ctrl+Alt+Right";
                    "Switch One Desktop Up" = "Ctrl+Alt+Up";
                    "Switch One Desktop Down" = "Ctrl+Alt+Down";
                    "Toggle Grid View" = "Meta+A";
                    "Window Close" = "Alt+Q";
                    "Window Operations Menu" = "Alt+R";

                    # Krohnkite
                    "KrohnkiteNextLayout" = "Ctrl+Shift+Meta+Right";
                    "KrohnkitePreviousLayout" = "Ctrl+Shift+Meta+Left";
                };
            };


            configFile = {
                "kwinrc"."Desktops"."Number" = {
                    value = 4;
                    # Forces kde to not change this value (even through the settings app).
                    immutable = true;
                };
                "kwinrc"."Desktops"."Rows" = {
                        value = 2;
                        immutable = true;
                };
                "kwinrc"."Windows"."RollOverDesktops" = {
                        value = true;
                        immutable = true;
                };

                "kwinrc"."Plugins"."krohnkiteEnabled" = {
                        value = true;
                        immutable = true;
                };

                "kwinrc"."krohnkite"."layoutOrder" = {
                    value = "tile,monocle,threecolumn,spiral";
                    immutable = true;
                };

                "kwinrc"."krohnkite"."screenGap" = {
                    value = 12;     # Outer gap: screen edge padding in pixels
                    immutable = true;
                };

                "kwinrc"."krohnkite"."tileLayoutGap" = {
                    value = 10;     # Inner gap: space between tiled windows in pixels
                    immutable = true;
                };
            };
        };
    };
}
