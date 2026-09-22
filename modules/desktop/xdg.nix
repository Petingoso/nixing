{
  config,
  lib,
  ...
}:
let
  inherit (config.custom) username enableHM;

  hmCfg = if enableHM then config.home-manager.users.${username} else null;

  # https://specifications.freedesktop.org/basedir-spec/latest/
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
in
lib.mkIf enableHM {
  # most of the random ass env vars taken from `pkgs.xdg-ninja`
  environment.sessionVariables = {
    inherit
      XDG_CACHE_HOME
      XDG_CONFIG_HOME
      XDG_DATA_HOME
      XDG_STATE_HOME
      ;

    ANDROID_HOME = "${hmCfg.xdg.dataHome}/android";
    CARGO_HOME = "${hmCfg.xdg.dataHome}/cargo";
    DOTNET_CLI_HOME = "${hmCfg.xdg.dataHome}/dotnet";
    GOPATH = "${hmCfg.xdg.dataHome}/go";
    GNUPGHOME = "${hmCfg.xdg.dataHome}/gnupg";
    GRADLE_USER_HOME = "${hmCfg.xdg.dataHome}/gradle";
    NUGET_PACKAGES = "${hmCfg.xdg.cacheHome}/NuGetPackages";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${hmCfg.xdg.configHome}/java";
    PARALLEL_HOME = "${hmCfg.xdg.configHome}/parallel";
    PYTHONSTARTUP = "${hmCfg.xdg.configHome}/python/pythonrc";
    RUSTUP_HOME = "${hmCfg.xdg.dataHome}/rustup";
    WINEPREFIX = "${hmCfg.xdg.dataHome}/wine";
    XAUTHORITY = "\$XDG_RUNTIME_DIR/Xauthority";
  };

  home-manager.users.${username} = {
    xdg = {
      cacheHome = "${hmCfg.home.homeDirectory}/.cache";
      configHome = "${hmCfg.home.homeDirectory}/.config";
      dataHome = "${hmCfg.home.homeDirectory}/.local/share";
      stateHome = "${hmCfg.home.homeDirectory}/.local/state";
      mimeApps = {
        enable = true;
        defaultApplications =
          let
            primary_browser = "firefox.desktop";
            secondary_browser = "chromium-browser.desktop";
            mail_client = "thunderbird.desktop";
            file_manager = "nemo.desktop";
            media_player = "mpv.desktop";
            image_viewer = "org.xfce.ristretto.desktop";
            text_editor = "nvim.desktop";
          in
          {
            "x-scheme-handler/heroic" = [ "heroic.desktop" ];
            "application/pdf" = [ "org.gnome.Evince.desktop" ];
            "text/html" = [
              primary_browser
              secondary_browser
            ];
            "x-scheme-handler/http" = [
              primary_browser
              secondary_browser
            ];
            "x-scheme-handler/https" = [
              primary_browser
              secondary_browser
            ];
            "x-scheme-handler/about" = [
              primary_browser
              secondary_browser
            ];
            "x-scheme-handler/unknown" = [
              primary_browser
              secondary_browser
            ];
            "x-scheme-handler/mailto" = [ mail_client ];
            "message/rfc822" = [ mail_client ];
            "x-scheme-handler/mid" = [ mail_client ];
            "inode/directory" = [ file_manager ];
            "audio/mp3" = [ media_player ];
            "audio/ogg" = [ media_player ];
            "audio/mpeg" = [ media_player ];
            "audio/aac" = [ media_player ];
            "audio/opus" = [ media_player ];
            "audio/wav" = [ media_player ];
            "audio/webm" = [ media_player ];
            "audio/3gpp" = [ media_player ];
            "audio/3gpp2" = [ media_player ];
            "video/mp4" = [ media_player ];
            "video/x-msvideo" = [ media_player ];
            "video/mpeg" = [ media_player ];
            "video/ogg" = [ media_player ];
            "video/mp2t" = [ media_player ];
            "video/webm" = [ media_player ];
            "video/3gpp" = [ media_player ];
            "video/3gpp2" = [ media_player ];
            "image/png" = [ image_viewer ];
            "image/jpeg" = [ image_viewer ];
            "image/gif" = [ media_player ];
            "image/avif" = [ image_viewer ];
            "image/bmp" = [ image_viewer ];
            "image/vnd.microsoft.icon" = [ image_viewer ];
            "image/svg+xml" = [ image_viewer ];
            "image/tiff" = [ image_viewer ];
            "image/webp" = [ image_viewer ];
            "text/plain" = [ text_editor ];
          };
      };
    };
  };
}
