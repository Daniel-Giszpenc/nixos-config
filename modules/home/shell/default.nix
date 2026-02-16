{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    imports = [
        ./language.nix
        ./ssh.nix
    ];

    options.home-modules.shell = with types; {
        direnv-enable = mkEnableOption "Enable direnv.";
        direnv-pkg = mkOption {
            type = package;
            default = pkgs.nix-direnv;
        };

        git-enable = mkEnableOption "Enable git.";
        git-pkg = mkOption {
            type = package;
            default = pkgs.git;
        };

        tmux-enable = mkEnableOption "Enable tmux.";
        tmux-pkg = mkOption {
            type = package;
            default = pkgs.tmux;
        };

        htop-enable = mkEnableOption "Enable htop.";
        htop-pkg = mkOption {
            type = package;
            default = pkgs.htop;
        };

        curl-enable = mkEnableOption "Enable curl.";
        curl-pkg = mkOption {
            type = package;
            default = pkgs.curl;
        };

        wget-enable = mkEnableOption "Enable wget.";
        wget-pkg = mkOption {
            type = package;
            default = pkgs.wget;
        };

        ncdu-enable = mkEnableOption "Enable ncdu.";
        ncdu-pkg = mkOption {
            type = package;
            default = pkgs.ncdu;
        };

        file-enable = mkEnableOption "Enable file.";
        file-pkg = mkOption {
            type = package;
            default = pkgs.file;
        };

        neofetch-enable = mkEnableOption "Enable neofetch.";
        neofetch-pkg = mkOption {
            type = package;
            default = pkgs.neofetch;
        };

        tldr-enable = mkEnableOption "Enable tldr.";
        tldr-pkg = mkOption {
            type = package;
            default = pkgs.tldr;
        };

        traceroute-enable = mkEnableOption "Install traceroute networking cli utility.";
        traceroute-pkg = mkOption {
            type = package;
            default = pkgs.traceroute;
        };

        dig-enable = mkEnableOption "Install dig networking cli utility.";
        dig-pkg = mkOption {
            type = package;
            default = pkgs.dig;
        };

        parallel-enable = mkEnableOption "Install parallel cli utility for running commands in parallel.";
        parallel-pkg = mkOption {
            type = package;
            default = pkgs.parallel;
        };

        tree-enable = mkEnableOption "Install tree cli utility.";
        tree-pkg = mkOption {
            type = package;
            default = pkgs.tree;
        };

        bat-enable = mkEnableOption "Install bat cli utility.";
        bat-pkg = mkOption {
            type = package;
            default = pkgs.bat;
        };
    };

    config = mkMerge [
        ( mkIf (cfg.direnv-enable)
        {
            home.packages = [ cfg.direnv-pkg ];
            programs.direnv = {
                enable = true;
                enableBashIntegration = true;
                nix-direnv.enable = true;
            };
        })

        ( mkIf (cfg.git-enable)
        {
            home.packages = [ cfg.git-pkg ];
            programs.git = {
                enable = true;
                settings.user = {
                    name = "Nero-Study-Hat";
                    email = "nerostudyhat@gmail.com";
                };
            };
        })

        ( mkIf (cfg.tmux-enable)
        {
            programs.tmux = {
                enable = true;
                package = pkgs.tmux;
            };
        })

        ( mkIf (cfg.htop-enable)
        {
            programs.htop = {
                enable = true;
                package = pkgs.htop;
            };
        })

        ( mkIf (cfg.curl-enable)
        { home.packages = [ cfg.curl-pkg ]; })

        ( mkIf (cfg.wget-enable)
        { home.packages = [ cfg.wget-pkg ]; })

        ( mkIf (cfg.ncdu-enable)
        { home.packages = [ cfg.ncdu-pkg ]; })

        ( mkIf (cfg.file-enable)
        { home.packages = [ cfg.file-pkg ]; })

        ( mkIf (cfg.neofetch-enable)
        { home.packages = [ cfg.neofetch-pkg ]; })

        ( mkIf (cfg.tldr-enable)
        { home.packages = [ cfg.tldr-pkg ]; })

        ( mkIf (cfg.traceroute-enable)
        { home.packages = [ cfg.traceroute-pkg ]; })

        ( mkIf (cfg.dig-enable)
        { home.packages = [ cfg.dig-pkg ]; })

        ( mkIf (cfg.parallel-enable)
        { home.packages = [ cfg.parallel-pkg ]; })

        ( mkIf (cfg.bat-enable)
        { home.packages = [ cfg.bat-pkg ]; })
    ];
}