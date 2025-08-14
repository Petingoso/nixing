{
  config,
  pkgs,
  ...
}: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users.${config.custom.username} = {
    extraGroups = ["wireshark"];
  };
}
