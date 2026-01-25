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
    # NixOS configuration for Linux
    nixosConfigurations.XPS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit emacs-config; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit emacs-config; };
          home-manager.users.c = { ... }: {
            imports = [
              ./common.nix
              ./linux.nix
            ];
            home.username = "c";
            home.homeDirectory = "/home/c";
          };
        }
      ];
    };

    # nix-darwin configuration for macOS
    darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit emacs-config; };
      modules = [
        ./darwin-system.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit emacs-config; };
          home-manager.users.chijoshi = { lib, ... }: {
            imports = [
              ./common.nix
              ./darwin.nix
            ];
            home.username = "chijoshi";
            home.homeDirectory = lib.mkForce "/Users/chijoshi";
          };
        }
      ];
    };
  };
}
