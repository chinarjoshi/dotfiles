{ config, ... }:

{
  programs.zsh.shellAliases = {
    rebuild = "nix run home-manager/master -- switch --flake '${config.home.homeDirectory}/nixos#mac'";
  };
}
