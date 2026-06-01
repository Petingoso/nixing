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
    evince
    fastfetch
    krita
    pavucontrol
    qalculate-gtk
    wine
    # pcloud

    xdg-utils
    # hydrapaper
  ];
}
