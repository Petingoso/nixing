{config, ...}: let
  inherit (config.custom) username;
in {
  programs.adb.enable = true;

  users.users.${username} = {
    extraGroups = ["adbusers"];
  };
}
