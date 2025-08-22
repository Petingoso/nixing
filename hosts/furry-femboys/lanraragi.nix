{
  config,
  self,
  lib,
  pkgs,
  ...
}: {
  age.secrets.lanraragi.file = "${self}/secrets/lanraragi.age";

  services.lanraragi = {
    package = pkgs.callPackage "${self}/pkgs/lanraragi/package.nix" {};
    enable = true;
    port = 8500;
    passwordFile = config.age.secrets.lanraragi.path;
  };

  systemd.services.lanraragi.environment = {
    MOJO_REVERSE_PROXY = "1";
  };

  fileSystems."/var/lib/private/lanraragi" = {
    device = "/data/lanraragi";
    options = ["bind"];
  };

  systemd.tmpfiles.rules = [
    "d /data/lanraragi 0700 root root - - --no-override"
  ];
}
