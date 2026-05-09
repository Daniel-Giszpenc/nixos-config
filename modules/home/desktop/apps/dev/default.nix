{ options, config, lib, pkgs, pkgs-stable, rootPath, ... }:

with lib;
let
    cfg = config.home-modules.desktop.apps.dev;
in
{
    imports = [
        ./godot.nix
        ./ghostty.nix
        ./neovim.nix
    ];

    options.home-modules.desktop.apps.dev = with types; {
        vscode-enable = mkEnableOption "Enable vscode.";
        vscode-pkg = mkOption {
            type = package;
            default = pkgs.vscode;
        };
        cool-retro-term-enable = mkEnableOption "Enable cool-retro-term.";
        cool-retro-term-pkg = mkOption {
            type = package;
            default = pkgs.cool-retro-term;
        };
        githup-desktop-enable = mkEnableOption "Enable githup-desktop.";
        githup-desktop-pkg = mkOption {
            type = package;
            default = pkgs.github-desktop;
        };
        renpy-enable = mkEnableOption "Enable renpy visual novel engine.";
        renpy-pkg = mkOption {
            type = package;
            default = pkgs-stable.renpy;
        };

        ciscoPacketTracer-enable = mkEnableOption "Enable ciscoPacketTracer networking tool.";
        ciscoPacketTracer-pkg = mkOption {
            type = package;
            default = pkgs-stable.ciscoPacketTracer8;
        };

        pi-coding-agent-enable = mkEnableOption "Enable pi-coding-agent tool.";
        pi-coding-agent-pkg = mkOption {
            type = package;
            default = pkgs.pi-coding-agent; # not on stable yet
        };
    };

    config = mkMerge [
        ( mkIf (cfg.vscode-enable)
        {
            # --- VSCODE CONFIG SETTING ---
            # "editor.fontSize": 15,
            # "editor.fontFamily": "Cascadia Code",
            # "editor.codeLensFontFamily": "Cascadia Code",
            # "editor.fontLigatures": true,
            # "editor.minimap.enabled": false,
            # "workbench.colorTheme": "One Dark Pro Darker",
            # "workbench.iconTheme": "material-icon-theme",

            # keybinds.json config
            # {
            #     "key": "ctrl+enter",
            #     "command": "file-browser.open"
            # },

            # {
            #     "key": "ctrl+'", // or use "key": "\""
            #     "command": "editor.action.insertSnippet",
            #     "when": "editorHasSelection",
            #     "args": {
            #         "snippet": "\"${TM_SELECTED_TEXT}\""
            #     },
            # },
            # ---
            programs.vscode = {
                enable = true;
                package = cfg.vscode-pkg;
                mutableExtensionsDir = true;
            };
        })
        ( mkIf (cfg.cool-retro-term-enable)
        {
            home.packages = [ cfg.cool-retro-term-pkg ];
        })
        ( mkIf (cfg.githup-desktop-enable)
        {
            home.packages = [ cfg.githup-desktop-pkg ];
        })
        ( mkIf (cfg.renpy-enable)
        {
            home.packages = [ cfg.renpy-pkg ];
        })

        ( mkIf (cfg.ciscoPacketTracer-enable)
        {
            home.packages = [ cfg.ciscoPacketTracer-pkg ];
        })

        ( mkIf (cfg.pi-coding-agent-enable)
        {
            home.packages = [ cfg.pi-coding-agent-pkg ];
        })
    ];
}
