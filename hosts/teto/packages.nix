{
  pkgs,
  config,
  self,
  ...
}: let
  inherit (config.mystuff.other.system) username;
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
    # mcomix
  ];

  users.users.${username}.packages = with pkgs; [
    rclone
    bitwarden
    evince
    fastfetch
    krita
    pavucontrol
    qalculate-gtk
    wineWowPackages.waylandFull
    pcloud

    xdg-utils
  ];
}
