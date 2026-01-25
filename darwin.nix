{ config, lib, pkgs, emacs-config, ... }:

let
  glibtool = pkgs.runCommand "glibtool" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.libtool}/bin/libtool $out/bin/glibtool
    ln -s ${pkgs.libtool}/bin/libtoolize $out/bin/glibtoolize
  '';
in
{
  system.stateVersion = 5;
  system.primaryUser = "chijoshi";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.libtool
    glibtool
    pkgs.cmake
    pkgs.iproute2mac
  ];

  programs.zsh.enable = true;

  users.users.chijoshi.shell = pkgs.zsh;

  # Window management (matching sway config)
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";

      # No gaps (matching sway)
      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 0;

      # Mouse behavior (matching sway focus.mouseWarping = "container")
      mouse_follows_focus = "on";
      focus_follows_mouse = "off";

      # Window appearance (matching sway window.border = 0)
      window_shadow = "off";
      window_border = "off";

      # Opacity (matching inactive-windows-transparency -o 0.8)
      # Note: requires SIP disabled
      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.8";

      # Split behavior (matching autotiling)
      auto_balance = "on";
    };
  };

  # Global hotkeys (matching sway keybindings)
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Applications
      cmd - return : emacsclient -c --eval '(vterm-full-toggle)'
      cmd + shift - return : open -a Alacritty || open -a Terminal
      cmd - space : open -a "Google Chrome"
      cmd - e : emacsclient -c --eval '(notes-open-daily)'
      cmd - s : screencapture -i ~/Desktop/screenshot-$(date +%Y%m%d-%H%M%S).png

      # Window management
      cmd - q : yabai -m window --close
      cmd + shift - c : yabai --restart-service

      # Focus window
      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      # Move/warp window
      cmd + shift - h : yabai -m window --warp west || yabai -m window --move rel:-20:0
      cmd + shift - j : yabai -m window --warp south || yabai -m window --move rel:0:20
      cmd + shift - k : yabai -m window --warp north || yabai -m window --move rel:0:-20
      cmd + shift - l : yabai -m window --warp east || yabai -m window --move rel:20:0

      # Fullscreen (native macOS)
      cmd - f : yabai -m window --toggle native-fullscreen

      # Spaces (requires SIP disabled for space commands)
      # cmd - 1 : yabai -m space --focus 1
      # cmd - 2 : yabai -m space --focus 2
      # ... etc

      # Toggle float
      cmd + shift - space : yabai -m window --toggle float

      # Balance windows
      cmd + shift - b : yabai -m space --balance
    '';
  };

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit emacs-config; };
  home-manager.users.chijoshi = { config, ... }: {
    imports = [ ./common.nix ];

    home.username = "chijoshi";
    home.homeDirectory = lib.mkForce "/Users/chijoshi";

    programs.zsh.shellAliases = {
      rebuild-darwin = "sudo darwin-rebuild switch --flake '${config.home.homeDirectory}/nixos#mac'";
    };

    programs.zsh.initExtra = ''
      unsetopt BEEP
      unsetopt HIST_BEEP
      unsetopt LIST_BEEP
    '';
  };
}
