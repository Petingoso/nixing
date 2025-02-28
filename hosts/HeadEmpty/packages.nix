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
    compsize
    font-manager
    gnome-disk-utility
    lxappearance
    ncpamixer
    libreoffice
    nemo
    nemo-fileroller
    piper
    qbittorrent
    xfce.ristretto
    p7zip
    wdisplays
    # mcomix
  ];

  users.users.${username}.packages = with pkgs; [
    bitwarden
    evince
    fastfetch
    krita
    lutris
    pavucontrol
    pcsx2
    qalculate-gtk
    steamtinkerlaunch
    stremio
    texliveMedium
    tor-browser
    ungoogled-chromium
    wineWowPackages.waylandFull
    youtube-music
    xdg-utils
    rclone
    pcloud

    (callPackage "${self}/pkgs/ludusavi.nix" {})
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
}
