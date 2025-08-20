{
  description = "petingoso's flake";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    inherit (nixpkgs) lib;
    nixosConfigurations = import ./hosts {inherit inputs self;};
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-unstable-lates.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    agenix.url = "github:ryantm/agenix";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
}
