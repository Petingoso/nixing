{self,config,lib,pkgs, ...}: {
  environment.etc."current-flake".source = self;
  # export packages as a fancy list
  environment.etc."current-system-packages".text =(
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted);
}
