{
  description = "NixOS configuration for XPS";

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
          home-manager.users.c = import ./home.nix;
        }
      ];
    };
  };
}
