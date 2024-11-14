{
  description = "my nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {

      "marco" = nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";

        modules = [
          ./hosts/marco/configuration.nix
          inputs.vscode-server.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "disabled";
              users = { "plumps" = import ./hosts/marco/home.nix; };
            };
          }
        ];
      };

      "kudos" = nixpkgs.lib.nixosSystem {

        system = "aarch64-linux";

        modules = [
          ./hosts/kudos/configuration.nix
          inputs.vscode-server.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "disabled";
              users = { "plumps" = import ./hosts/kudos/home.nix; };
            };
          }
        ];
      };
    };
  };
}
