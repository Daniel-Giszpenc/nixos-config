{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    cfg = config.home-modules.desktop.hyprland;
in
{
    options.home-modules.desktop.hyprland = with types; {
        enable = mkEnableOption "Whether to setup hyprland with associated packages and config on this desktop.";
        monitors = mkOption {
            type = listOf str;
            # main PC
            default = [
                "DP-2, 3440x1440@100, auto-left, 1"
                "HDMI-A-1, 1680x1050@60, 0x0, 1, transform, 1"
            ];
        };
    };

    config = mkIf cfg.enable {
        home.pointerCursor = {
            gtk.enable = true;
            # x11.enable = true;
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 16;
        };

        gtk = {
            enable = true;
            theme = {
                package = pkgs.flat-remix-gtk;
                name = "Flat-Remix-GTK-Grey-Darkest";
            };
            iconTheme = {
                package = pkgs.adwaita-icon-theme;
                name = "Adwaita";
            };
            font = {
                name = "Sans";
                size = 11;
            };
        };

        wayland.windowManager.hyprland = {
            enable = true;
            package = null;
            # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
            portalPackage = null;
            xwayland.enable = true;

            # true conflicts with uwsm set in system config
            systemd.enable = false;

            settings = {
                debug = {
                    disable_logs = false;
                };

                input = {
                    sensitivity = 0.25;
                    force_no_accel = 0; 
                };


                "$terminal" = "cool-retro-term";
                "$mainMod" = "SUPER";
                "$menu" = "rofi -show drun -show-icons";
                "$screenshot" = ''grim -g "$(slurp)" - | swappy -f -'';

                monitor = cfg.monitors;

                xwayland = {
                    force_zero_scaling = true;
                    use_nearest_neighbor = true;
                };

                general = { 
                    gaps_in = 5;
                    gaps_out = 20;
                    border_size = 2;
                    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                    "col.inactive_border" = "rgba(595959aa)";
                    layout = "dwindle";
                    allow_tearing = true;
                };

                decoration = {
                    rounding = 15;

                    # Change transparency of focused and unfocused windows
                    active_opacity = 1.0;
                    inactive_opacity = 0.95;
                    fullscreen_opacity = 1.0;

                    # does not work any longer
                    # drop_shadow = true;
                    # shadow_range = 4;
                    # shadow_render_power = 3;
                    # "col.shadow" = "rgba(1a1a1aee)";

                    blur = {
                        enabled = true;
                        size = 3;
                        passes = 1;
                        vibrancy = 0.1696;
                    };
                };

                misc = { 
                    force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
                    disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
                };

                animations = {
                    enabled = true;
                    bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
                    animation = [
                        # "workspaces, 1, 2, default, fade"

                        "windows, 1, 7, myBezier"
                        "windowsOut, 1, 7, default, popin 80%"
                        "border, 1, 10, default"
                        "borderangle, 1, 8, default"
                        "fade, 1, 7, default"
                        "workspaces, 1, 6, default"
                    ];
                };

                master = {
                    new_status = true;
                };

                dwindle = {
                    pseudotile = true;
                    preserve_split = true;
                    # no_gaps_when_only = 2;
                };

                bind = [
                    "ALT, SPACE, exec, $menu"
                ];

                workspace = [
                    "100, special:ghostty"
                    "101, special:vesktop"
                ];

                bindr = [
                    "$mainMod, T, exec, $terminal"
                    
                    "alt, Q, killactive"
                    "$mainMod, V, togglefloating"
                    "$mainMod, F, fullscreen"
                    ",code:107, exec, $screenshot" # camera icon key on my keyboard

                    "$mainMod, RIGHT, movetoworkspace, -1"
                    "$mainMod, LEFT, movetoworkspace, +1"
                    
                    # special workspace logic
                    "$mainMod D, DOWN, movetoworkspace, +0"
                    # pocket special workspace logic
                    "$mainMod, A, togglespecialworkspace, ghostty"
                    "$mainMod, R, movetoworkspace, special:ghostty" # has to be ALT, $mainMod moves to different special for some reason
                    # discord pocket special workspace logic
                    "$mainMod, D, togglespecialworkspace, vesktop"
                    "$mainMod D, UP, movetoworkspace, special:vesktop"

                    "$mainMod, P, pseudo, dwindle"
                    "$mainMod, J, togglesplit, dwindle"
                ];

                bindl = [
                    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                    # Requires playerctl
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPrev, exec, playerctl previous"
                    ", XF86AudioNext, exec, playerctl nex"
                    # Requires brightnessctl
                    ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
                    ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ];
                
                bindm = [
                    "$mainMod, mouse:272, movewindow"
                    "$mainMod, mouse:273, resizewindow"
                    "$mainMod ALT, mouse:272, resizewindow"
                ];

                windowrulev2 = [
                    "suppressevent maximize, class:.*"
                    "float, class:(com.github.hluk.copyq)"
                ];

                exec-once = [
                    "waybar & swww"
                    "hypridle"
                    "sleep 3 && uwsm app -- copyq --start-server"

                    # Autostart Special Workspace Apps
                    "[workspace special:ghostty silent] uwsm app -- ghostty"
                    "[workspace special:vesktop silent] uwsm app -- vesktop"
                ];

                # needs updating for UWSM
                # env = [
                #     "XCURSOR_SIZE,24"
                #     "HYPRCURSOR_SIZE,24"
                #     "QT_STYLE_OVERRIDE,kvantum"
                #     "USE_WAYLAND_GRIM,true"
                #     "GDK_SCALE,1"
                #     "XDG_SESSION_TYPE,wayland"
                #     "WLR_NO_HARDWARE_CURSORS,1"
                # ];
            };
        };
    };

}