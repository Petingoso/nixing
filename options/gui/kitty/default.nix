{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.programs.kitty;
  inherit (config.custom) username enableHM;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options.custom.programs = {
    kitty.enable = lib.mkEnableOption "kitty";
  };

  # NOTE: Needs home manager
  config = lib.mkIf cfg.enable && enableHM {
    home-manager.users.${username} = {
      programs.kitty.enable = true;

      programs.kitty = {
        settings = {
          font_family = "Jetbrains Mono";
          bold_font = "auto";
          italic_font = "auto";

          bold_italic_font = "auto";
          font_size = 16;

          adjust_line_height = 0;

          adjust_column_width = 0;

          disable_ligatures = "always";

          background_opacity = "0.6";

          cursor_shape = "block";

          scrollback_lines = 10000;

          mouse_hide_wait = 3;

          url_style = "double";

          open_url_with = "firefox";

          url_prefixes = "http https file ftp gemini irc gopher mailto news git";

          detect_urls = true;
          # url_excluded_characters

          select_by_word_characters = "@-./_~?&=%+#";

          focus_follows_mouse = true;

          enable_audio_bell = false;

          remember_window_size = true;

          tab_bar_edge = "top";

          tab_bar_style = "powerline";
          tab_powerline_style = "angled";

          close_on_child_death = true;

          allow_remote_control = true;

          listen_on = "unix:/tmp/kitty";
        };

        keybindings =
          {
            "ctrl+f3" = "detach_tab";
            "kitty_mod + q" = "close_window";
            "kitty_mod + f" = "next_window";
            "kitty_mod + b" = "previous_window";
            "kitty_mod + k" = "move_window_foward";
            "kitty_mod + l" = "move_window_backward";
            "kitty_mod + p" = "set_tab_title";
            "ctrl + plus" = "change_font_size all +2.0";
            "ctrl + minus" = "change_font_size all -2.0";
          }
          // builtins.listToAttrs (builtins.genList (x: {
              name = "ctrl+alt+${builtins.toString x}";
              value = "goto_tab ${builtins.toString x}";
            })
            10);
      };
    };
  };
}
