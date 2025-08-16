{
  self,
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.mystuff.other.system.username} = {
    home.file.".local/bin/togglegaps" = {
      text = ''
        #!/usr/bin/env bash

        gaps=$(hyprctl getoption general:gaps_in | grep type ) #custom type: 0 0 0 0
        digits=$(echo "$gaps" | tr -dc '0-9')
        if [[ $digits =~ ^[0]+$ ]]; then #if only 0000
                hyprctl keyword general:gaps_in 5
                hyprctl keyword general:gaps_out 5
        else
                hyprctl keyword general:gaps_in 0
                hyprctl keyword general:gaps_out 0
        fi
      '';
      executable = true;
    };
  };
}
