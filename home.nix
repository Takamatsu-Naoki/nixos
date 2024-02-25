{ pkgs, lib, ... }: {
  home.username = "naoki";
  home.homeDirectory = "/home/naoki";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    wl-clipboard
    gh
    nil
    lua-language-server
    nodePackages_latest.typescript-language-server
    dracula-theme
    gnome.adwaita-icon-theme
    pamixer
    brightnessctl
    swayidle
    wezterm
    firefox
    thunderbird
    rclone
    jmtpfs
    feh
    vlc
    inkscape
    gimp
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
        oil-nvim
        kanagawa-nvim
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
        pulseaudio = {
          format-muted = "[{volume}%] 󰝟 ";
          format = "[{volume}%] {icon} ";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾"];
          };
        };
        backlight = {
          format = "[{percent}%] {icon} ";
          format-icons = ["󱩎" "󱩏" "󱩐" "󱩑" "󱩓" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
        };
        battery = {
          format = "[{capacity}%] {icon} ";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        clock = {
          format = "[{:%c}]";
        };
      }];
      style = import ./waybar/style.nix;
    };

    wofi = {
      enable = true;
      settings = {
        show = "drun";
        insensitive = true;
        key_down = "Tab";
        key_up = "ISO_Left_Tab";
        key_pgup = "Control_L-u";
        key_pgdn = "Control_L-d";
        key_expand = "space";
        key_forward = "Control_L-j";
        key_backward = "Control_L-k";
      };
      style = import ./wofi/style.nix;
    };

    ncmpcpp = {
      enable = true;
    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    ''; 
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
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
      keybindings = lib.mkOptionDefault {
        "Mod4+q" = "kill";
        "Mod4+slash" = "exec ${pkgs.wezterm}/bin/wezterm";
        "Mod4+Return" = "exec ${pkgs.wofi}/bin/wofi";
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
            timeout 300 "systemctl suspend" \
            timeout 600 "systemctl hibernate" \
            before-sleep "${pkgs.swaylock}/bin/swaylock -fF"
          '';
          always = true;
        }
      ];
    };
  };

  services.mako = {
    enable = true;
    backgroundColor = "#282a36";
    textColor = "#f8f8f2";
    borderColor = "#44475a";
    extraConfig = ''
      [urgency=low]
      border-color=#282a36

      [urgency=normal]
      border-color=#44475a

      [urgency=high]
      border-color=#ff5555
    '';
  };
}
