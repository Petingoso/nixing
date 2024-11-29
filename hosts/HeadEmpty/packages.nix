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
    steam
    steamtinkerlaunch
    stremio
    texliveMedium
    tor-browser
    ungoogled-chromium
    vesktop
    vscodium
    wineWowPackages.waylandFull
    youtube-music
    xdg-utils
  ];
}