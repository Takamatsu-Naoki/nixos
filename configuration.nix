{ config, lib, pkgs, ... }:

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
  services.auto-cpufreq.enable = true;
  
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us"; 
  };

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
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerdfonts
      powerline-fonts
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
      	sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
      	monospace = ["JetBrainsMono Nerd Font"  "Noto Color Emoji"];
      	emoji = ["Noto Color Emoji"];
      };
    };
  };

  system.stateVersion = "23.11";
}

