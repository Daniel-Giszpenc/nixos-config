{ inputs, lib, config, options, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.roles.workstation.system;
in
{
    imports = [ ../../core ];

    options.roles.workstation.system = with types; {
        enable = mkEnableOption "";
        hostname = mkOption {
            type = str;
            default = "nero";
        };
        desktop-defaults = mkOption {
            type = bool;
            default = true;
            description = "Enable desktop with associated packages and config.";
        };
        virtualization = mkOption {
            type = bool;
            default = true;
            description = "Enable virtualization with associated packages and config.";
        };
        yubikey = mkOption {
            type = bool;
            default = true;
            description = "Enable yubikey support with associated packages and config.";
        };
        sops = mkOption {
            type = bool;
            default = true;
            description = "Setup sops-nix with associated packages and config.";
        };
        tailscale = mkOption {
            type = bool;
            default = true;
            description = "Setup tailscale VPN with associated packages and config.";
        };
        wireshark = mkOption {
            type = bool;
            default = true;
            description = "Setup Wireshark with associated packages and config.";
        };
        signal = mkOption {
            type = bool;
            default = true;
            description = "Setup Signal messenger app with associated packages and config.";
        };
    };

    config = mkMerge [
        ( mkIf (cfg.enable)
        {
            nixpkgs.config.allowUnfree = true;
            nix.settings = {
                experimental-features = "nix-command flakes";
                # Deduplicate and optimize nix store
                auto-optimise-store = true;
            };

            time.timeZone = "America/New_York";

            networking.hostName = cfg.hostname;
            networking.useDHCP = lib.mkDefault true;
            networking.nameservers = [
                "10.0.0.3"
            ];

            programs.ssh.startAgent = true;
            programs.ssh.agentTimeout = "2h";

            # environment.pathsToLink = [ "/share/bash-completion" ];
            environment.variables.EDITOR = "code --wait";
            environment.sessionVariables.NIXOS_OZONE_WL = "1";

            fonts.fontDir.enable = true;
            fonts.enableDefaultPackages = true;
            fonts.enableGhostscriptFonts = true;

            # enable sound with pipewire
            security.rtkit.enable = true;
            services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
            };

            system.stateVersion = "25.11";
        })

        (mkIf cfg.enable (mkMerge [
            ( mkIf (cfg.desktop-defaults)
            {
                system-modules.desktop = {
                    sddm = true;
                    kde = true;
                    hyprland = true;
                };
            })
            ( mkIf (cfg.virtualization)
            {
                system-modules.virtualization = {
                    enable = true;
                    user = "nero";
                    virtualbox = true;
                    kvm-qemu = false;
                    docker = true; # rootless
                };
            })
            ( mkIf (cfg.yubikey)
            {
                system-modules.yubikey = {
                    enable = true;
                };
            })
            ( mkIf (cfg.sops)
            {
                system-modules.sops = {
                    enable = true;
                };
            })
            ( mkIf (cfg.tailscale)
            {
                system-modules.tailscale = {
                    enable = true;
                };
            })
            ( mkIf (cfg.wireshark)
            {
                system-modules.wireshark = {
                    enable = true;
                };
            })
            ( mkIf (cfg.signal)
            {
                system-modules.signal = {
                    enable = true;
                };
            })
        ]))

    ];
}
