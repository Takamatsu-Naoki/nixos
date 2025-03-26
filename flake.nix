{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-fonts.url = "github:Takamatsu-Naoki/nixos-fonts";
    nixos-fonts.inputs.nixpkgs.follows = "nixpkgs";
    lucky-roll.url = "github:Takamatsu-Naoki/lucky-roll";
    lucky-roll.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      "TallOaks" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inputs = {
                lucky-roll-pkgs = inputs.lucky-roll.packages.${system};
              };
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.naoki = import ./home.nix;
          }
        ];
      };
    };
  };
}
