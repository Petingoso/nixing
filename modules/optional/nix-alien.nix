{
  config,
  self,
  ...
}: {
  programs.nix-ld.enable = true;
  environment.systemPackages = with self.inputs.nix-alien.packages.${config.custom.platform}; [
    nix-alien
  ];
}
