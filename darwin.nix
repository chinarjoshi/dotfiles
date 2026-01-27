{ config, lib, pkgs, ... }:

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

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [ "d12frosted/emacs-plus" ];
    casks = [ "emacs-plus-app" ];
  };

  environment.systemPackages = [
    pkgs.libtool
    glibtool
    pkgs.iproute2mac
  ];

  programs.zsh.enable = true;
  users.users.chijoshi.shell = pkgs.zsh;

  system.defaults.CustomUserPreferences = {
    "com.google.Chrome" = {
      NSUserKeyEquivalents = {
        "Find..." = "^f";
      };
    };
  };

  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 0;
      mouse_follows_focus = "on";
      focus_follows_mouse = "off";
      window_shadow = "off";
      window_border = "off";
      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.8";
      auto_balance = "on";
    };
    extraConfig = ''
      yabai -m rule --add app="emacs" manage=on
    '';
  };

  launchd.user.agents.emacs = {
    command = "/bin/zsh -l -c 'cd /Users/chijoshi && /opt/homebrew/bin/emacs --fg-daemon'";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = "/Users/chijoshi";
    };
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : /opt/homebrew/bin/emacsclient -c -n --eval "(vterm-full-toggle)" && yabai -m window --focus $(yabai -m query --windows | jq -r '.[] | select(.app=="Emacs") | .id' | tail -n1)
      cmd + shift - return : open -a Kitty
      cmd + shift - space : open -a "Google Chrome"
      cmd - e : /opt/homebrew/bin/emacsclient -c -n --eval "(notes-open-daily)" && yabai -m window --focus $(yabai -m query --windows | jq -r '.[] | select(.app=="Emacs") | .id' | tail -n1)
      cmd - s : screencapture -i ~/Desktop/screenshot-$(date +%Y%m%d-%H%M%S).png

      cmd - q : yabai -m window --close
      cmd + shift - c : yabai --restart-service

      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      cmd + shift - h : yabai -m window --warp west || yabai -m window --move rel:-20:0
      cmd + shift - j : yabai -m window --warp south || yabai -m window --move rel:0:20
      cmd + shift - k : yabai -m window --warp north || yabai -m window --move rel:0:-20
      cmd + shift - l : yabai -m window --warp east || yabai -m window --move rel:20:0

      cmd - f : yabai -m window --toggle zoom-fullscreen
      cmd + ctrl - space : yabai -m window --toggle float
      cmd + shift - b : yabai -m space --balance
    '';
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.chijoshi = { config, pkgs, ... }: {
    imports = [ ./common.nix ];

    home.username = "chijoshi";
    home.homeDirectory = lib.mkForce "/Users/chijoshi";

    programs.zsh.shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake '${config.home.homeDirectory}/nixos#mac'";
    };

    programs.zsh.initContent = ''
      unsetopt BEEP
      unsetopt HIST_BEEP
      unsetopt LIST_BEEP
      export LIBRARY_PATH="/opt/homebrew/lib/gcc/current''${LIBRARY_PATH:+:$LIBRARY_PATH}"
    '';
  };
}
