{
    config,
    inputs,
    pkgs,
    ...
}: let
    inherit (config.mystuff.other.system) username;
in {
    imports = [ inputs.agenix.nixosModules.default ];

    users.users.${username}.packages = [
        inputs.agenix.packages.${pkgs.stdenv.system}.default
    ];
}
