{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.utility;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    # imports = [ ];

    options.home-modules.desktop.apps.utility = with types; {
        protonvpn-enable = mkEnableOption "Enable direnv.";
        protonvpn-pkg = mkOption {
            type = package;
            default = pkgs.protonvpn-cli_2;
        };

        gparted-enable = mkEnableOption "Enable gparted.";
        gparted-pkg = mkOption {
            type = package;
            default = pkgs.gparted;
        };

        simplescreenrecorder-enable = mkEnableOption "Enable simplescreenrecorder.";
        simplescreenrecorder-pkg = mkOption {
            type = package;
            default = pkgs.simplescreenrecorder;
        };

        yt-dlp-enable = mkEnableOption "Enable yt-dlp.";
        yt-dlp-pkg = mkOption {
            type = package;
            default = pkgs.yt-dlp;
        };

        yubico-authenticator-enable = mkEnableOption "Enable simplescreenrecorder.";
        yubico-authenticator-pkg = mkOption {
            type = package;
            default = pkgs.yubioath-flutter;
        };

        ffmpeg-enable = mkEnableOption "Enable ffmpeg.";
        ffmpeg-pkg = mkOption {
            type = package;
            default = pkgs.ffmpeg;
        };

        usbimager-enable = mkEnableOption "Enable usbimager.";
        usbimager-pkg = mkOption {
            type = package;
            default = pkgs.usbimager;
        };

        picocrypt-enable = mkEnableOption "Enable picocrypt.";
        picocrypt-pkg = mkOption {
            type = package;
            default = pkgs.picocrypt;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.protonvpn-enable)
        { home.packages = [ cfg.protonvpn-pkg ]; })

        ( mkIf (cfg.gparted-enable)
        { home.packages = [ cfg.gparted-pkg ]; })

        ( mkIf (cfg.simplescreenrecorder-enable)
        { home.packages = [ cfg.simplescreenrecorder-pkg ]; })

        ( mkIf (cfg.yt-dlp-enable)
        { home.packages = [ cfg.yt-dlp-pkg ]; })

        ( mkIf (cfg.yubico-authenticator-enable)
        { home.packages = [ cfg.yubico-authenticator-pkg ]; })

        ( mkIf (cfg.ffmpeg-enable)
        { home.packages = [ cfg.ffmpeg-pkg ]; })

        ( mkIf (cfg.usbimager-enable)
        { home.packages = [ cfg.usbimager-pkg ]; })

        ( mkIf (cfg.picocrypt-enable)
        { home.packages = [ cfg.picocrypt-pkg ]; })
    ];
}