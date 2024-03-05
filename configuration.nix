{ inputs, pkgs, ... }:

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

  services.xserver.desktopManager.runXdgAutostartIfNone = true;

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

  programs.fish.enable = true;

  users.users.naoki = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
  hardware.opengl.enable = true;
  security.pam.services.swaylock = {};

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ] ++ ( with inputs.nixos-fonts.packages.x86_64-linux; [
      anzu-moji
      azukifont
      rii-tegaki-fude
      rii-tegaki-n
    ]);
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif CJK JP"];
      	sansSerif = ["Noto Sans CJK JP"];
      	emoji = ["Noto Color Emoji"];
      	monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };

  system.stateVersion = "23.11";
}

