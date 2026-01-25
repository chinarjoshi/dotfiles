{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-config = {
      url = "github:chinarjoshi/init.el";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, emacs-config, ... }: {
    nixosConfigurations.XPS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit emacs-config; };
      modules = [
        home-manager.nixosModules.home-manager
        ./linux.nix
      ];
    };

    darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit emacs-config; };
      modules = [
        home-manager.darwinModules.home-manager
        ./darwin.nix
      ];
    };
  };
}
