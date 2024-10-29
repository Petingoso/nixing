{
  config,
  pkgs,
  ...
}: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users.${config.mystuff.other.system.username} = {
    extraGroups = ["wireshark"];
  };
}
