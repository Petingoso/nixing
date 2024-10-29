{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in {
  fonts.packages = attrValues {
    inherit
      (pkgs)
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      corefonts
      vistafonts
      ;
    nerdfonts = pkgs.nerdfonts.override {
      fonts = ["JetBrainsMono" "Iosevka"];
    };
  };
}
