{
  self,
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.mystuff.other.system.username} = {
    home.packages = [pkgs.glib pkgs.swaybg];
    home.file.".local/bin/theme_changer_WL" = {
      text = builtins.readFile ./theme.sh;
      executable = true;
    };
  };
}
