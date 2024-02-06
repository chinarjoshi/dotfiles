{ config, lib, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet" "rd.systemd.show_status=0" 
      "rd.udev.log_level=3" "udev.log_priority=3"
    ];
  };

  # Create a single user
  users.users.c = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" "video" ];
  };

  # Enable networking
  networking = {
    wireless.iwd.enable = true;
    hostName = "XPS";
  };

  # Set time zone.
  time.timeZone = "US/Eastern";

  # Privilege escalation
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = ["c"];
        noPass = true;
        keepEnv = true;
      }]; 
    };
  }; 

  # Configurable programs
  programs = {
    zsh.enable = true;
    firefox.enable = true;
    waybar.enable = true;
    hyprland = { 
      enable = true; 
      xwayland.enable = false; 
    };
    git = {
      enable = true;
      config = {
        user.name = "Chinar Joshi";
        user.email = "chinarjoshi7@gmail.com";
        init.defaultBranch = "main";
        credential.helper = "cache";
      };
    };
  };

  # Systemd services
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    interception-tools = {
      enable = true;
      plugins = with pkgs; [ interception-tools-plugins.caps2esc ];
      udevmonConfig = ''
       - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
         DEVICE:
           EVENTS:
             EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
     '';
    };    
  };

  # Rest of the packages
  environment.systemPackages = with pkgs; [
    foot
    firefox
    helix
    dbus
    swaybg
    tealdeer
    waybar    
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
