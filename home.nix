{ pkgs, lib, ... }: {
  home.username = "naoki";
  home.homeDirectory = "/home/naoki";
  home.stateVersion = "23.11";

  home.sessionPath = [
    "$HOME/dev/nixos/my-scripts"
    "${pkgs.fcitx5-mozc}/lib/mozc"
  ];

  home.sessionVariables = {
    GRIM_DEFAULT_DIR = "$HOME/gdrive/pics/ss";
  };

  home.packages = with pkgs; [
    openconnect
    wl-clipboard
    grim
    slurp
    git-lfs
    gh
    p7zip
    nil
    dracula-theme
    gnome.adwaita-icon-theme
    brightnessctl
    swayidle
    dmenu-wayland
    google-chrome
    thunderbird
    rclone
    jmtpfs
    qview
    vlc
    inkscape
    gimp
    obs-studio
  ];

  programs = {
    git = {
      enable = true;
      userName = "Takamatsu Naoki";
      userEmail = "Takamatsu0331@outlook.jp";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        direnv hook fish | source
      '';
      plugins = [
        { name = "bobthefisher"; src = pkgs.fishPlugins.bobthefisher.src; }
        { name = "z"; src = pkgs.fishPlugins.z.src; }
        { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
        {
          name = "dracula";
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "fish";
            rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
            sha256 = "1xim3yfqf2hmy0gcb58za1cdbgl23bpxqsc815q6qnm6yh8vhahz";
          };
        }
      ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      extraLuaConfig = import ./neovim/configuration.nix;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: with p; [
          nix
          rust
          html
          css
          json
          javascript
          typescript
          svelte
        ]))
        oil-nvim
        kanagawa-nvim
        none-ls-nvim
        plenary-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp_luasnip
        cmp-nvim-lsp
        luasnip
        friendly-snippets
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    swaylock = {
      enable = true;
      settings = {
        color = "222222";
      };
    };

    waybar = {
      enable = true;
      settings = [{
        layer = "top";
        position = "top";
        height = 24;
        spacing = 4;
        modules-left = ["sway/scratchpad" "sway/workspaces"];
        modules-center = ["sway/window"];
        modules-right = ["pulseaudio" "backlight" "battery" "clock"];
        "sway/scratchpad" = {
          format = "[ {count} ]";
        };
        "sway/workspaces" = {
          format = "{icon}: {value}";
          format-icons = {
            "1" = " ";
            "2" = " ";
            "3" = "󰗹 ";
            "4" = " ";
            "5" = "󰋋 ";
            "6" = " ";
            "7" = " ";
            "8" = " ";
            "9" = " ";
            "10" = "󰍹 ";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };
        pulseaudio = {
          format-muted = "[{volume}%] 󰝟 ";
          format = "[{volume}%] {icon}";
          format-icons = {
            default = ["󰕿 " "󰖀 " "󰕾 "];
          };
        };
        backlight = {
          format = "[{percent}%] {icon}";
          format-icons = ["󱩎 " "󱩏 " "󱩐 " "󱩑 " "󱩓 " "󱩓 " "󱩔 " "󱩕 " "󱩖 " "󰛨 "];
        };
        battery = {
          format = "[{capacity}%] {icon}";
          format-icons = ["󰁺 " "󰁻 " "󰁼 " "󰁽 " "󰁾 " "󰁿 " "󰂀 " "󰂁 " "󰂂 " "󰁹 "];
        };
        clock = {
          format = "[{:%c}]";
        };
      }];
      style = import ./waybar/style.nix;
    };

    ncmpcpp = {
      enable = true;
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require "wezterm"
        local config = wezterm.config_builder()
        config.font = wezterm.font_with_fallback {
          "JetBrainsMono Nerd Font",
          "Noto Sans CJK JP",
        } 
        return config
      '';
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      focus.followMouse = "no";
      input = {
        "*" = {
	        xkb_layout = "us";
	      };
        "type:touchpad" = {
          scroll_method = "two_finger";
        };
      };
      seat = {
        "*" = {
          hide_cursor = "3000";
        };
      };
      workspaceOutputAssign = [
        {
          workspace = "10";
          output = "HDMI-A-1";
        }
      ];
      keybindings = lib.mkOptionDefault {
        "Mod4+0" = "workspace number 10";
        "Mod4+Shift+0" = "move container to workspace number 10";
        "Mod4+q" = "kill";
        "Mod4+d" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";
        "Mod4+g" = "exec ${pkgs.grim}/bin/grim";
        "Mod4+Shift+g" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g -";
        "Mod4+slash" = "exec ${pkgs.wezterm}/bin/wezterm";
        "Mod4+Return" = "exec ${pkgs.dmenu-wayland}/bin/dmenu-wl_run";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
      };
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      startup = [
        {
          command = ''
            swayidle -w \
            timeout 300 "${pkgs.swaylock}/bin/swaylock -fF" \
            timeout 480 "systemctl hibernate" \
            before-sleep "${pkgs.swaylock}/bin/swaylock -fF"
          '';
          always = true;
        }
      ];
    };
    extraConfig = "workspace number 1";
  };

  services.mako = {
    enable = true;
    backgroundColor = "#282a36";
    textColor = "#f8f8f2";
    borderColor = "#44475a";
    font = "Noto Sans CJK JP";
    extraConfig = ''
      [urgency=low]
      border-color=#282a36

      [urgency=normal]
      border-color=#44475a

      [urgency=high]
      border-color=#ff5555

      [summary="Font problem"]
      invisible=1
    '';
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/naoki/music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-skk ];
  };
}
