{
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    corefonts
    vista-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];
}
