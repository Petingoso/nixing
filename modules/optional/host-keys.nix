{
  lib,
  config,
  ...
}:
{
  config.services.openssh = {
    enable = lib.mkDefault false;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
