{
  lib,
  ...
}:
{
  config.services.openssh = {
    enable = lib.mkDefault false;
    generateHostKeys = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
