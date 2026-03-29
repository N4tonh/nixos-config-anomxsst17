{
  description = "Mi configuración de NixOS con Flakes y Home Manager";

  inputs = {
  	determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
        	url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, home-manager, determinate, ... }@inputs: {
  	nixosConfigurations.twarlien = nixpkgs.lib.nixosSystem
{
	system = "x86_64-linux";
	specialArgs = { inherit inputs; };
	modules = [
		./configuration.nix
		determinate.nixosModules.default
		home-manager.nixosModules.home-manager
		{
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
			home-manager.users.anomxsst17 = import ./home.nix;
		}
	];
      };
    };
}
