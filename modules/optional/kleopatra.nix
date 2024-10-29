{pkgs, ...}: {
  environment.systemPackages = [pkgs.kleopatra];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
}
