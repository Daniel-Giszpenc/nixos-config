{ options, config, lib, pkgs, pkgs-stable, ... }:

### NOTE: default user shell is set by nixos-configuration, not home-manager

with lib;
let
    cfg = config.home-modules.shell.language;
    chosen-pkgs = if (cfg.pkgs-stable == true) then pkgs-stable else pkgs;
in
{
    options.home-modules.shell.language = with types; {
        pkgs-stable = mkEnableOption "Whether to us nixpkgs-stable as opposed to unstable.";
        enable-all = mkEnableOption "Enable all shell languages here.";
        bash-enable = mkEnableOption "Enable and configure bash.";
        zsh-enable = mkEnableOption "Enable and configure zsh.";
    };

    config = mkMerge [
        ({
            home.sessionVariables = {
                FLAKE = "/.nixflake";
            };
        })
        ( mkIf (cfg.enable-all || cfg.bash-enable)
        {
            home.packages = [
                chosen-pkgs.bash
                chosen-pkgs.bash-completion
            ];
            programs.bash = {
                enable = true;
                enableCompletion = true;
                shellAliases = {
                    cl = "clear";
                    res = "result/activate && rm -r result";
                    flake-update = "cd $FLAKE && nix flake update";
                    stardom = "sudo nixos-rebuild switch --flake $FLAKE#stardom --no-update-lock-file";
                    nero = "cd ~/tmp && nix run home-manager -- build --flake $FLAKE#nero";
                    starfief = "sudo nixos-rebuild switch --flake $FLAKE#starfief --no-update-lock-file";
                    alaric = "cd ~/tmp && nix run home-manager -- build --flake $FLAKE#alaric";
                };
                historyIgnore = [ "ls" "cd" "cl" "clear" "exit" ];
                bashrcExtra = ''eval "$(direnv hook bash)"'';
            };
        })

        # https://mynixos.com/home-manager/options/programs.zsh
        ( mkIf (cfg.enable-all || cfg.zsh-enable)
        {
            # home.packages = [
            #     chosen-pkgs.zsh
            # ];
            programs.zsh = {
                enable = true;
                enableCompletion = true;
                syntaxHighlighting.enable = true;
                autosuggestion.enable = true;

                history = {
                    size = 10000;
                    ignoreAllDups = true;
                    ignorePatterns = ["ls *"];
                };

                historySubstringSearch = {
                    enable = true;
                    searchUpKey = ["\\eOA"];
                    searchDownKey = ["\\eOB"];
                };

                shellAliases = {
                    cl = "clear";
                    res = "result/activate && rm -r result";
                    flake-update = "cd $FLAKE && nix flake update";
                    stardom = "sudo nixos-rebuild switch --flake $FLAKE#stardom --no-update-lock-file";
                    nero = "cd ~/tmp && nix run home-manager -- build --flake $FLAKE#nero";
                    starfief = "sudo nixos-rebuild switch --flake $FLAKE#starfief --no-update-lock-file";
                    alaric = "cd ~/tmp && nix run home-manager -- build --flake $FLAKE#alaric";
                };

                oh-my-zsh = {
                    enable = true;
                    theme = "gnzh";
                    plugins = [
                        "git"
                    ];
                        # "zsh-autosuggestions"
                        # "zsh-autocomplete"
                };

                dotDir = "${config.xdg.configHome}/zsh";
                initContent = ''
                    # Evaluate direnv hook
                    eval "$(direnv hook zsh)"
                '';
            };
        })
    ];
}