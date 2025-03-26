{ inputs, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/nvme0n1p5";
    kernelParams = ["resume_offset=46800896"];
    initrd.kernelModules = [ "amdgpu" ];
  };

  fileSystems."/home/naoki/mnt/sda1" = {
   device = "/dev/sda1";
   fsType = "auto";
   options = [ "defaults" "user" "rw" "utf8" "noauto" "umask=000" ];
 };

  networking = {
    hostName = "TallOaks";
    networkmanager.enable = true; 
  };

  powerManagement.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  services.upower.enable = true;
  
  time.timeZone = "Asia/Tokyo";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us"; 
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          muhenkan = "oneshot(control)";
          henkan = "oneshot(shift)";
          katakanahiragana = "backspace";
          leftalt = "oneshot(alt)";
          rightalt = "oneshot(altgr)";
          meta = "oneshot(meta)";
          rightcontrol = "oneshot(meta)";
          capslock = "esc";
          esc = "capslock";
          leftshift = "enter";
        };
      };
    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  programs = {
    fish = {
      enable = true;
    };

    steam = {
      enable = true;
    };
  };

  users.users.naoki = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;
  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ];})
    ] ++ ( with inputs.nixos-fonts-pkgs; [
      anzu-moji
      azukifont
      rii-tegaki-fude
      rii-tegaki-n
      coming-soon
      logistra
    ]);
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif CJK JP"];
      	sansSerif = ["Noto Sans CJK JP"];
      	emoji = ["Noto Color Emoji"];
      	monospace = ["JetBrainsMono Nerd Font" "Noto Sans CJK JP"];
      };
    };
  };

  system.stateVersion = "23.11";
}

