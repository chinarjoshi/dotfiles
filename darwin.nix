{ config, ... }:

{
  programs.zsh.shellAliases = {
    rebuild-darwin = "sudo darwin-rebuild switch --flake '${config.home.homeDirectory}/nixos#mac'";
  };
}
