{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    cfg = config.system-modules.signal;
in
{
    options.system-modules.signal = with types; {
        enable = mkEnableOption "Enable Signal messenger desktop app.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            signal-desktop
        ];
    };
}