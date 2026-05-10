{ pkgs,self, ... }:
{
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
    bitwarden-desktop
    evince
    fastfetch
    krita
    # lutris
    pavucontrol
    pcsx2
    qalculate-gtk
    steamtinkerlaunch
    # stremio
    texliveMedium
    tor-browser
    ungoogled-chromium
    wine
    pear-desktop
    xdg-utils
    rclone
    pcloud
    ludusavi
    (callPackage "${self}/pkgs/scripts" { })
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
}
