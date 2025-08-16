{
  self,
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.mystuff.other.system.username} = {
    home.file.".local/bin/powermenu" = {
      text = ''
        #!/usr/bin/env bash

        prompt="rofi -dmenu -theme ~/.config/rofi/launchers/power.rasi"


        shutdown=" Shutdown"
        reboot="󰦛 Restart"
        lock=" Lock"
        logout="󰗽 Logout"
        suspend="🖪 Suspend"
        cancel="󰖭 Cancel"

        option="$cancel\n$shutdown\n$reboot\n$lock\n$suspend\n$logout"

        select="$(echo -e "$option" | $prompt -p "Option: ")"

        case $select in
        	$shutdown)
        		poweroff
        		;;
        	$reboot)
        		reboot
        		;;
        	$lock)
        		loginctl lock-session
        		;;
        	$suspend)
        		systemctl suspend
        		;;
        	$logout)
        		loginctl terminate-session self
        esac
      '';
      executable = true;
    };
  };
}
