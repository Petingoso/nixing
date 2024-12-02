{
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    corefonts
    vistafonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];
}
