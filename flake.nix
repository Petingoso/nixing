{
  description = "petingoso's flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # common

    #hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    #running dynamic apps easily
    nix-alien.url = "github:thiagokokada/nix-alien";

    #secret management
    agenix.url = "github:ryantm/agenix";

    #vscode extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    #theme generation
    matugen.url = "github:/InioX/Matugen";

  };

  outputs = {self, ...} @ inputs: {
    nixosConfigurations = import ./hosts { inherit self inputs; };
  };
}
