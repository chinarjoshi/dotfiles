{ pkgs, ... }:

let
  glibtool = pkgs.runCommand "glibtool" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.libtool}/bin/libtool $out/bin/glibtool
    ln -s ${pkgs.libtool}/bin/libtoolize $out/bin/glibtoolize
  '';
in
{
  # Required for nix-darwin
  system.stateVersion = 5;
  system.primaryUser = "chijoshi";
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = [
    pkgs.vim
    pkgs.libtool
    glibtool
    pkgs.cmake
  ];

  # Create /etc/zshrc that loads nix-darwin environment
  programs.zsh.enable = true;

  # Set default shell to zsh
  users.users.chijoshi.shell = pkgs.zsh;

  # Window management
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
      mouse_follows_focus = "on";
    };
  };

  # Global hotkeys
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Emacs
      cmd - return : emacsclient -c --eval '(vterm-full-toggle)'
      cmd - e : emacsclient -c --eval '(notes-open-daily)'

      # Focus window (replaces hammerspoon)
      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east
    '';
  };
}
