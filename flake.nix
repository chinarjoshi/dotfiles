{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-config = {
      url = "github:chinarjoshi/init.el";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-config, ... }: {
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

    # Standalone Home Manager for macOS
    homeConfigurations.mac = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = { inherit emacs-config; };
      modules = [
        ./common.nix
        ./darwin.nix
        {
          home.username = "chijoshi";
          home.homeDirectory = "/Users/chijoshi";
        }
      ];
    };
  };
}
