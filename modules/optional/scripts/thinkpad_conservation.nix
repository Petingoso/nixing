{config, ...}: {
  home-manager.users.${config.mystuff.other.system.username} = {
    home.file.".local/bin/thinkpad_conservation_mode" = {
      text = ''
        #!/usr/bin/env bash
        if [ $1 = 1 ]; then
        	echo "Enabling battery limit"
                echo 70 > /sys/class/power_supply/BAT1/charge_stop_threshold
                echo 50 > /sys/class/power_supply/BAT1/charge_start_threshold
        else
        	echo "Disabling battery limit"
                echo 100 > /sys/class/power_supply/BAT1/charge_stop_threshold
                echo 0 > /sys/class/power_supply/BAT1/charge_start_threshold
        fi

      '';
      executable = true;
    };
  };
}
