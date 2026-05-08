{ options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
in
{
    options.home-modules.desktop.apps.dev = with types; {
        neovim-enable = mkEnableOption "Enable neovim.";
    };

    config = mkIf cfg.neovim-enable {
        programs.nvf = {
            enable = true;
            # your settings need to go into the settings attribute set
            # most settings are documented in the appendix
            settings = {
                vim.viAlias = false;
                vim.vimAlias = true;
                vim.lsp = {
                    enable = true;
                };
                vim.extraPlugins = {
                    astrocore = {
                        package = pkgs.vimPlugins.astrocore;
                        setup = "require('astrocore').setup({})";
                    };
                    astroui = {
                        package = pkgs.vimPlugins.astroui;
                        setup = "require('astroui').setup({})";
                    };
                };
            };
        };
    };
}