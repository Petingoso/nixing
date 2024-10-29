{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in {
  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = false;
    info.enable = false;
    man = {
      enable = true;
      generateCaches = false;
      man-db.enable = false;
      mandoc.enable = true;
    };
    nixos = {
      includeAllModules = true;
    };
  };

  environment.systemPackages = attrValues {
    inherit
      (pkgs)
      man-pages
      man-pages-posix
      ;
  };
}
