{ options, config, lib, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.shell.ssh-client;
in
{
    options.home-modules.shell.ssh-client = with types; {
        enable = mkEnableOption "Enable ssh client.";
    };

    config = mkIf cfg.enable {
        programs.ssh = {
            enable = true;
            matchBlocks = {
                "*" = {
                    addKeysToAgent = "yes";
                };
                "github" = {
                    host = "github.com";
                    identitiesOnly = true;
                    user = "git";
                    #TODO: change ssh to to -sk with hardware key being used
                    identityFile = "~/.ssh/id_ed25519_github";
                };
            };
        };
    };
}