{config, ...}: let
  inherit (config.mystuff.other.system) username;
in {
  programs.adb.enable = true;

  users.users.${username} = {
    extraGroups = ["adbusers"];
  };
}
