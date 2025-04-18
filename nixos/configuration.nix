{ config, lib, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet" "rd.systemd.show_status=0" "iwlwifi.power_save=0"
      "rd.udev.log_level=3" "udev.log_priority=3"
    ];
  };

  # Create a single user
  users.users.c = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" "networkmanager" "video" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbtN5PmfwSZefLuc8k3vLTBvJTqqKpp8E+8zzTyswB5 c@XPS"
    ];
  };

  virtualisation.docker.enable = true;

  # Enable networking
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = false;
    };
    hostName = "XPS";
  };

  # Set time zone.
  time.timeZone = "US/Eastern";

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

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

  # Enable haredware video-acceleratoin
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Configurable programs
  programs = {
    zsh.enable = true;
    firefox.enable = true;
    sway.enable = true;
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        credential.helper = "store";
      };
    };
  };
  environment.variables.NIXOS_OZONE_WL = "1";

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

    openssh.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
    getty.autologinUser = "c";
    # ydotool.enable = true;
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
    fd
    ripgrep
    light
    lf
    wl-clipboard
    wlsunset
    libglvnd
    mesa
    libGL
    grim
    slurp
    pulseaudio
    fzf
    egl-wayland
    btop
    git-credential-manager
    glxinfo
    jq
    libglvnd
    obsidian
    swayidle
    tree
    zip
    unzip
    usbutils
    wl-clipboard
    wlsunset
    (python3.withPackages (ps: with ps; [ i3ipc ]))
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
