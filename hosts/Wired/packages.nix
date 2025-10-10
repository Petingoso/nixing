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
    btrbk
    compsize
    font-manager
    gnome-disk-utility
    libreoffice
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
    rclone
    bitwarden
    calibre
    ckan
    evince
    fastfetch
    heroic
    # hydrus
    krita
    lutris
    pavucontrol
    pcsx2
    osu-lazer-bin
    prismlauncher
    qalculate-gtk
    steamtinkerlaunch
    # stremio
    texliveMedium
    tor-browser
    ungoogled-chromium
    wineWowPackages.waylandFull
    youtube-music
    # miru
    pcloud
    obsidian

    (olympus.override {celesteWrapper = steam-run;})
    (callPackage "${self}/pkgs/steam-run-ksp.nix" {})
    ludusavi
    xdg-utils
    gamescope
    r2modman
    config.boot.kernelPackages.vhba
  ];
  programs.steam.enable = true;
  programs.cdemu.enable = true;
  programs.cdemu.gui = true;
}
