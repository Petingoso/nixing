{pkgs, ...}: {
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    pam
    polkit_gnome
  ];
}
