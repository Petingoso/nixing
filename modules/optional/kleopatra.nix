{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kdePackages.kleopatra ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
