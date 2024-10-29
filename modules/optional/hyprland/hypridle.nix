{
  pkgs,
  config,
  ...
}: let
  lock_cmd = "${pkgs.playerctl}/bin/playerctl pause; ${config.programs.hyprlock.package}/bin/hyprlock";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = lock_cmd;
        unlock_cmd = "";
        after_sleep_cmd = "";
        before_sleep_cmd = lock_cmd;
      };

      listener = [
        {
          timeout = 500;
          on-timeout = lock_cmd;
          on-resume = "";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
          on-resume = "";
        }
      ];
    };
  };
}
