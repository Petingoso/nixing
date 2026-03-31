{
  pkgs,
  config,
  ...
}: let
  inherit (config.custom) username;
in {
  environment.systemPackages = with pkgs; [
    baobab
    font-manager
    gnome-disk-utility
    libreoffice
    ncpamixer
    nemo
    nemo-fileroller
    qbittorrent
    p7zip
    wdisplays
    inetutils
    dig
    # mcomix
  ];

  users.users.${username}.packages = with pkgs; [
    rclone
    bitwarden-desktop
    evince
    fastfetch
    krita
    pavucontrol
    qalculate-gtk
    wineWowPackages.waylandFull
    # pcloud

    xdg-utils
    # hydrapaper
  ];
}
