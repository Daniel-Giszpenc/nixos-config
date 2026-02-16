{ options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

### NOTE: default user shell is set by nixos-configuration, not home-manager

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {}; # depends on dotnetCorePackages.sdk_version
in
{
    options.home-modules.desktop.apps.dev = with types; {
        godot3-enable = mkEnableOption "Enable godot3.";
        godot3-pkg = mkOption {
            type = package;
            default = pkgs.godot3;
        };
        godot3-mono-enable = mkEnableOption "Enable godot3-mono.";
        godot3-mono-pkg = mkOption {
            type = package;
            default = pkgs.godot3-mono;
        };
        godot4-enable = mkEnableOption "Enable godot4.";
        godot4-pkg = mkOption {
            type = package;
            default = pkgs.godotPackages_4_5.godot;
        };
        godot4-mono-enable = mkEnableOption "Enable godot4-mono.";
        godot4-mono-pkg = mkOption {
            type = package;
            default = pkgs.godot-mono;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.godot3-enable)
        { home.packages = [ cfg.godot3-pkg ]; })

        ( mkIf (cfg.godot3-mono-enable)
        { home.packages = [ cfg.godot3-mono-pkg ]; })

        ( mkIf (cfg.godot4-enable)
        { home.packages = [ cfg.godot4-pkg ]; })

        ( mkIf (cfg.godot4-mono-enable)
        { home.packages = [ cfg.godot4-mono-pkg ]; })
    ];
}