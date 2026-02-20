{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.basic;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    # imports = [ ];

    options.home-modules.desktop.apps.basic = with types; {
        brave-browser-enable = mkEnableOption "Enable brave-browser.";
        brave-browser-pkg = mkOption {
            type = package;
            default = pkgs.brave;
        };
        mullvad-browser-enable = mkEnableOption "Enable mullvad-browser.";
        mullvad-browser-pkg = mkOption {
            type = package;
            default = pkgs.mullvad-browser;
        };
        dolphin-enable = mkEnableOption "Enable dolphin.";
        dolphin-pkg = mkOption {
            type = package;
            default = pkgs.kdePackages.dolphin;
        };
        vesktop-enable = mkEnableOption "Enable vesktop.";
        vesktop-pkg = mkOption {
            type = package;
            default = pkgs.vesktop;
        };
        zoom-enable = mkEnableOption "Enable zoom.";
        zoom-pkg = mkOption {
            type = package;
            default = pkgs.zoom-us;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.brave-browser-enable)
        {
            home.packages = [ cfg.brave-browser-pkg ];
        })
        ( mkIf (cfg.mullvad-browser-enable)
        {
            home.packages = [ cfg.mullvad-browser-pkg ];
        })
        ( mkIf (cfg.dolphin-enable)
        {
            home.packages = [ cfg.dolphin-pkg ];
        })
        ( mkIf (cfg.vesktop-enable)
        {
            home.packages = [ cfg.vesktop-pkg ];
        })
        ( mkIf (cfg.zoom-enable)
        {
            home.packages = [ cfg.zoom-pkg ];
        })
    ];
}