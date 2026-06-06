{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  # Add your packages here...
  home.packages = with pkgs; [
    discord
    firefox
    vlc
    nautilus
    btop
    ghostty
    steam
    vscode
    spotify
    neovim
    obs-studio
    fastfetch
    zed-editor
    swww
    xenia-canary

   # Hyprland Specific
    wlr-randr
    pamixer
    brightnessctl
    rofi

    # Waybar extras
    pavucontrol
    swaynotificationcenter
    wlogout
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    starship
    fish
    grim
    slurp
    wine
    winetricks
    bottles
    scanmem
    pince
    nodejs
    heroic
    pcsx2
    rpcs3
    ryubing
    dolphin-emu
    inputs.nuhxboard.packages.${pkgs.system}.default
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

programs.waybar = {
    enable = true;

    # Waybar is launched via exec-once in Hyprland, not systemd
    systemd.enable = false;

    settings = {
      mainBar = {
        id       = "danny-waybar-hyprland";
        layer    = "top";
        position = "top";
        height   = 34;
        spacing  = 1;
        output   = ["DP-1"];

        # ── Layout ───────────────────────────────────────────────────────
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "custom/swaync"
          "clock"
        ];

        modules-right = [
          "temperature"
          "mpris"
          "memory"
          "cpu"
          "network"
          "pulseaudio"
          "idle_inhibitor"
          "keyboard-state"
          "custom/separator"
          "tray"
        ];

        # ── Left ─────────────────────────────────────────────────────────
        "hyprland/workspaces" = {
          format = "{id}:{name}";
          on-scroll-up   = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
          rewrite = {
            # strip common suffixes so the title stays short
            "(.*) — (.*)"    = "$1";
            "(.*) - (.*)"    = "$1";
            "(.*)Mozilla Firefox" = " $1";
            "(.*)Spotify"         = " Spotify";
          };
        };

        # ── Center ───────────────────────────────────────────────────────

        # swaync toggle — replaces theopn's dunst module
        # L-click: toggle notification panel
        # R-click: toggle Do Not Disturb
        "custom/swaync" = {
          format         = "󰵛";
          tooltip        = true;
          tooltip-format = "L: Notification panel / R: Toggle DND";
          on-click       = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
        };

        clock = {
          format         = "  {:%b %e %H:%M}";
          tooltip-format = "\t<big>{:%H:%M:%S}</big>\n\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode         = "month";
            mode-mon-col = 3;
            weeks-pos    = "left";
            iso-8601     = true;
            on-click-right = "mode";
            format = {
              weeks   = "<span color='#d8dee9'><i>{}</i></span>";
              today   = "<span color='#b48ead'><b><u>{}</u></b></span>";
            };
          };
          actions.on-click-right = "mode";
        };

        # ── Right ────────────────────────────────────────────────────────
        temperature = {
          # Run: ls /sys/class/hwmon/*/name to find your sensor
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          interval   = 1;
          format      = "{icon} {temperatureC}°C";
          format-icons = "";
        };

        mpris = {
          format         = "{status_icon} {player_icon}";
          format-paused  = "{status_icon} {player_icon}";
          on-click-middle = "";
          on-click-right  = "";
          player-icons = {
            default  = " ";
            firefox  = " ";
            spotify  = " ";
            chromium = " ";
            vlc      = " ";
          };
          status-icons = {
            playing = "";
            paused  = "";
          };
          max-length = 10;
        };

        memory = {
          interval = 1;
          format   = "󰍛 {used:0.1f}G";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        };

        cpu = {
          interval = 1;
          format   = "󰻠 {usage}%";
          tooltip  = false;
        };

        network = {
          format-wifi        = "󰤨 {essid}";
          format-ethernet    = "󰈀 eth";
          format-disconnected = "󰤭 offline";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  {ipaddr}";
          tooltip-format-ethernet = "{ifname}  {ipaddr}";
        };

        pulseaudio = {
          format        = "{icon} {volume}% {format_source}";
          format-muted  = "󰝟 {format_source}";
          format-source = "";
          format-source-muted = "󰍭";
          format-bluetooth       = "󰗾 ({icon}) {volume}% {format_source}";
          format-bluetooth-muted = "󰗿 ({icon}) {format_source}";
          format-icons = {
            headphone  = " ";
            hands-free = "󱡒 ";
            headset    = " ";
            phone      = " ";
            portable   = " ";
            car        = " ";
            default    = ["󰕿" "󰖀" "󰕾"];
          };
          on-click       = "${pkgs.pamixer}/bin/pamixer -t";
          on-click-right = "pavucontrol";
          scroll-step    = 1;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated   = "󰅶 ";
            deactivated = "󰾪 ";
          };
          tooltip-format-activated   = "CAFFEINATED";
          tooltip-format-deactivated = "might fall asleep";
        };

        keyboard-state = {
          numlock    = false;
          capslock   = true;
          scrolllock = false;
          format = {
            capslock = "{icon}";
          };
          format-icons = {
            locked   = "󰪛 CAPS";
            unlocked = " ";
          };
          binding-keys = [ 29 69 70 ];
        };

        "custom/separator" = {
          format  = "";
          tooltip = false;
          interval = "once";
        };

        tray = {
          icon-size = 20;
          spacing   = 10;
        };
      };
    };

    style = ''
      /*
       * Nord Waybar — danny
       * Font: JetBrainsMono Nerd Font
       */

      /* Nord Color Palette */
      @define-color color00 #2e3440;
      @define-color color01 #3b4252;
      @define-color color02 #434c5e;
      @define-color color03 #4c566a;
      @define-color color04 #d8dee9;
      @define-color color05 #e5e9f0;
      @define-color color06 #eceff4;
      @define-color color07 #8fbcbb;
      @define-color color08 #88c0d0;
      @define-color color09 #81a1c1;
      @define-color color10 #5e81ac;
      @define-color color11 #bf616a;
      @define-color color12 #d08770;
      @define-color color13 #ebcb8b;
      @define-color color14 #a3be8c;
      @define-color color15 #ba8baf;

      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
        border-radius: 12px;
      }

      window#waybar {
        margin: 10px 10px;
        background: rgba(46, 52, 64, 0.85);
        color: @color06;
      }


      /* ── Left ──────────────────────────────────────────────────────── */

      #workspaces {
        padding: 3px 3px;
      }

      #workspaces button {
        padding: 0px 9px;
        min-width: 1px;
        color: @color04;
        background: transparent;
      }

      #workspaces button.active {
        color: @color00;
        background-color: @color06;
      }

      #workspaces button.urgent {
        background-color: @color11;
      }

      #window {
        padding: 0px 10px;
        margin: 3px 3px;
        color: @color04;
        font-style: italic;
      }

      window#waybar.empty #window {
        background-color: transparent;
        color: transparent;
      }


      /* ── Center ────────────────────────────────────────────────────── */

      #custom-swaync {
        color: @color08;
        padding: 0px 5px;
        margin: 3px 3px;
      }

      #clock {
        padding: 0 5px;
        margin: 3px 3px;
      }


      /* ── Right ─────────────────────────────────────────────────────── */

      #temperature,
      #mpris,
      #memory,
      #cpu,
      #network,
      #pulseaudio,
      #idle_inhibitor,
      #tray {
        margin: 1px 1px;
        padding: 0 5px;
      }

      #mpris.playing {
        background-color: @color13;
        color: @color00;
      }

      #memory,
      #cpu {
        color: @color04;
      }

      #pulseaudio.muted {
        color: @color07;
      }

      #idle_inhibitor {
        color: @color07;
      }

      #idle_inhibitor.activated {
        background-color: @color11;
        color: @color06;
      }

      #keyboard-state label.locked {
        padding: 0 5px;
        color: @color14;
      }

      #custom-separator {
        color: @color03;
        padding: 1px 1px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: @color11;
      }
    '';
  };

  # Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      icon-theme = "Papirus";
      drun-display-format = "{name}";
      display-drun = "Search Applications...";
      scroll-method = 0;
      disable-history = false;
      sidebar-mode = false;
      columns = 2;
      lines = 9;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1e1e1e";
        bg-alt = mkLiteral "#2a2a2a";
        bg-selected = mkLiteral "#3b4252";
        fg = mkLiteral "#d8dee9";
        fg-dim = mkLiteral "#616e88";
        font = "JetBrainsMono Nerd Font 13";
      };
      "window" = {
        background-color = mkLiteral "@bg";
        border = mkLiteral "0px";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "20px";
        width = mkLiteral "700px";
      };
      "mainbox" = {
        background-color = mkLiteral "transparent";
        spacing = mkLiteral "10px";
      };
      "inputbar" = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "10px 14px";
        spacing = mkLiteral "8px";
        children = mkLiteral "[prompt, entry]";
      };
      "prompt" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-dim";
      };
      "entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        placeholder-color = mkLiteral "@fg-dim";
      };
      "listview" = {
        background-color = mkLiteral "transparent";
        columns = 2;
        lines = 9;
        spacing = mkLiteral "6px";
        scrollbar = false;
      };
      "element" = {
        background-color = mkLiteral "transparent";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px 10px";
        spacing = mkLiteral "10px";
        orientation = mkLiteral "horizontal";
      };
      "element selected" = {
        background-color = mkLiteral "@bg-selected";
        text-color = mkLiteral "@fg";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        size = mkLiteral "32px";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        vertical-align = mkLiteral "0.5";
      };
      "element normal" = {
        text-color = mkLiteral "@fg";
      };
      "element alternate" = {
        background-color = mkLiteral "transparent";
      };
    };
  };

  # Ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.1;
      background-blur-radius = 20;
      keybind = [
      "ctrl+c=copy_to_clipboard"
      "ctrl+shift+c=text:\x03"
      "ctrl+v=paste_from_clipboard"
      ];
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "amikizzy";
        email = "ozrul96@gmail.com";
      };
    };
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      monitor = [
        #"HDMI-A-1,highrr,auto,1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        layout = "master";
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(000000ff)";
        resize_on_border = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 0;
        active_opacity = 1;
        inactive_opacity = 1;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          ignore_window = true;
          color = "rgba(20,20,20,0.5)";
        };
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "snap, 0.2, 0, 0, 1" ];
        animation = [
          "windows, 0"
          "layers, 0"
          "fade, 0"
          "border, 0"
          "borderangle, 0"
          "zoomFactor, 0"
          "workspaces, 1, 2, snap, slide"
        ];
      };

      input = {
        kb_layout = "us";
        touchpad = {
          tap-to-click = false;
          scroll_factor = 1;
          natural_scroll = true;
          clickfinger_behavior = true;
          middle_button_emulation = true;
          disable_while_typing = true;
        };
      };

      cursor = {
        no_warps = true;
      };

      render = {
        direct_scanout = 1;
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        vfr = true;
        vrr = 0;
        focus_on_activate = true;
      };

      bind = [
        # Core
        "SUPER, S, exec, grim /home/danny/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" /home/danny/Pictures/$(date +%Y-%m-%d_%H-%M-%S).png"
        "SUPER, space, exec, ghostty"
        "SUPER SHIFT, F, togglefloating"
        "SUPER, E, exec, rofi -show drun"
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"

        # Workspace Navigation
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Workspace Manipulation
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Window Manipulation
        "SUPER SHIFT, left, layoutmsg, mfact -0.05"
        "SUPER SHIFT, right, layoutmsg, mfact +0.05"
        "SUPER SHIFT, F, togglefloating"

        # Quit
        "SUPER SHIFT, Q, exit"
      ];

      binde = [
        # Volume
        ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2"
        ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2"
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t"

        # Brightness
        ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-"

        # Backlight
        "SUPER, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl --class leds --device kbd_backlight set 1%+"
        "SUPER, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl --class leds --device kbd_backlight set 1%-"
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      exec-once = [
        "waybar"
        "swaync"
        "swww-deamon"
        "sleep 1 && swww img /home/danny/Downloads/nyc.jpg"
     ];
    };
  };

programs.fish = {
  enable = true;
  interactiveShellInit = ''
    starship init fish | source
  '';
};

programs.starship = {
  enable = true;
  settings = {
    add_newline = false;
    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };
  };
};

# EasyEffects noise suppression
  services.easyeffects = {
    enable = true;
    preset = "discord-noise-suppression";
    extraPresets = {
      discord-noise-suppression = {
        input = {
          blocklist = [];
          "plugins_order" = [ "rnnoise#0" ];
          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = false;
            "input-gain" = 0.0;
            "model-path" = "";
            "output-gain" = 0.0;
            release = 20.0;
            "vad-thres" = 50.0;
            wet = 0.0;
          };
        };
      };
    };
  };

# Do not change this!
  home.stateVersion = "25.11";
}
