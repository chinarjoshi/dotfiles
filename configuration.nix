{ config, lib, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  time.timeZone = "America/Los_Angeles";

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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


  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
  services.resolved = {
    enable = false;
  };

  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };


  # Enable haredware video-acceleratoin
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
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
    sway.enable = true;
    dconf.enable = true;
  };

  environment.variables = {
    XCURSOR_SIZE = "48";  # or 64 if you want larger
    XCURSOR_THEME = "Adwaita";  # or your preferred theme
    NIXOS_OZONE_WL = "1";
  };  # Use the systemd-boot EFI boot loader.

  fonts.packages = with pkgs; [
    garamond-libre
    inter
    lora
    nerd-fonts.inconsolata
  ];

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

  # System-level packages only
  environment.systemPackages = with pkgs; [
    firefox-bin
    dbus
    swaybg
    waybar
    light
    wlsunset
    libglvnd
    mesa
    libGL
    pulseaudio
    egl-wayland
    git-credential-manager
    glxinfo
    usbutils
    adwaita-icon-theme
    gsettings-desktop-schemas
    (python3.withPackages (ps: with ps; [ i3ipc ]))
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
