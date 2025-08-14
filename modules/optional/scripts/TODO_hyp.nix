{
  config,
  self,
  ...
}: {
  home-manager.users.${config.mystuff.other.system.username} = {
    home.file.".local/bin/hyp" = {
      text = ''
         #!/bin/sh
        cd ~

        mkdir -p /tmp/themes/kitty/
        mkdir -p /tmp/themes/rofi/
        mkdir -p /tmp/themes/hyprland/
        mkdir -p /tmp/themes/nvim/

        cp -r ${self}/misc/kitty/* /tmp/themes/kitty/
        cp -r ${self}/misc/rofi/* /tmp/themes/rofi/
        cp -r ${self}/misc/hyprland/* /tmp/themes/hyprland/

        echo 'vim.cmd("colorscheme gruvbox")' > /tmp/themes/nvim/theme

        chmod 775 -R /tmp/themes/

        dbus-run-session Hyprland
      '';
      executable = true;
    };
  };
}
