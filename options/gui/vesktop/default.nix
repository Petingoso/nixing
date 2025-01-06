{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mystuff.programs.vesktop;
  inherit (config.mystuff.other.system) username;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib.strings) concatStrings;
in {
  options.mystuff.programs.vesktop = {
    enable = mkEnableOption "vesktop";
  };

  config = mkIf cfg.enable {
    users.users.${username}.packages = [
      (pkgs.vesktop.overrideAttrs (old: {
        # patches = (old.patches or []) ++ [./readonlyFix.patch];
        # thanks aleph :3
        # https://github.com/AlephNought0/Faery/blob/main/modules/home/programs/graphical/vesktop/patchedvesktop.patch
        # thanks poz
        postFixup = concatStrings [
          old.postFixup
          ''
            wrapProgram $out/bin/vesktop --add-flags "--ozone-platform=wayland"
          ''
        ];
      }))
    ];

    home-manager.users.${username} = {
      xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
        discordBranch = "ptb";
        firstLaunch = false;
        arRPC = "on";
        splashColor = "rgb(220, 221, 222)";
        splashBackground = "oklab(0.321044 -0.000249296 -0.00927344)";
        minimizeToTray = true;
      };

      xdg.configFile."vesktop/themes/theme.css".source = ./theme.css;
      xdg.configFile."vesktop/settings/settings.json".text = builtins.toJSON {
        notifyAboutUpdates = false;
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [];
        enabledThemes = ["./theme.css"]; 
        enableReactDevtools = true;
        transparent = true;
        winCtrlQ = false;
        plugins = {
          BadgeAPI.enabled = true;
          CommandsAPI.enabled = true;
          ContextMenuAPI.enabled = true;
          MemberListDecoratorsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          MessagePopoverAPI.enabled = true;
          NoticesAPI.enabled = true;
          ServerListAPI.enabled = true;
          SettingsStoreAPI.enabled = true;
          NoTrack.enabled = true;
          Settings = {
            enabled = true;
            settingsLocation = "aboveActivity";
          };
          BetterUploadButton.enabled = true;
          ClearURLs.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          FakeNitro = {
            enabled = true;
            enableEmojiBypass = true;
            emojiSize = 48;
            transformEmojis = true;
            enableStickerBypass = true;
            stickerSize = 160;
            transformStickers = true;
            transformCompoundSentence = false;
            enableStreamQualityBypass = true;
          };
          FavoriteEmojiFirst.enabled = true;
          FixImagesQuality.enabled = true;
          GameActivityToggle.enabled = true;
          GifPaste.enabled = true;
          IgnoreActivities = {
            enabled = true;
            ignoredActivities = [];
          };
          ImageZoom = {
            enabled = true;
            saveZoomValues = true;
            invertScroll = true;
            nearestNeighbour = false;
            square = false;
            zoom = 2;
            size = 100;
            zoomSpeed = 0.5;
          };
          MemberCount.enabled = true;
          MessageLogger = {
            enabled = true;
            deleteStyle = "text";
            ignoreBots = false;
            ignoreSelf = false;
            ignoreUsers = "";
            ignoreChannels = "";
            ignoreGuilds = "";
          };
          MutualGroupDMs.enabled = true;
          NoProfileThemes.enabled = true;
          PermissionsViewer = {
            enabled = true;
            permissionsSortOrder = 0;
            defaultPermissionsDropdownState = false;
          };
          PinDMs.enabled = true;
          PlatformIndicators = {
            enabled = true;
            list = true;
            badges = true;
            messages = true;
            colorMobileIndicator = true;
          };
          PreviewMessage.enabled = true;
          RelationshipNotifier = {
            enabled = true;
            notices = true;
            offlineRemovals = true;
            friends = true;
            friendRequestCancels = true;
            servers = true;
            groups = true;
          };
          SearchReply.enabled = true;
          ServerListIndicators = {
            enabled = true;
            mode = 3;
          };
          ServerProfile.enabled = true;
          ShikiCodeblocks = {
            enabled = true;
            # theme = "https://raw.githubusercontent.com/shikijs/shiki/0b28ad8ccfbf2615f2d9d38ea8255416b8ac3043/packages/shiki/themes/dark-plus.json";
            # tryHljs = "SECONDARY";
            # uesDevIcon = "GREYSCALE";
            bgOpacity = 100;
          };
          ShowTimeouts.enabled = true;
          ViewIcons = {
            enabled = true;
            format = "png";
            imgSize = "2048";
          };
          ViewRaw = {
            enabled = true;
            clickMethod = "Left";
          };
          VoiceMessages = {
            enabled = true;
            noiseSuppression = true;
            echoCancellation = true;
          };
          WebContextMenus = {
            enabled = true;
            addBack = true;
          };
          WebKeybinds.enabled = true;
          GreetStickerPicker.enabled = false;
          WhoReacted.enabled = true;
          SecretRingToneEnabler.enabled = false;
        };
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1682768329526;
        };
      };
    };
  };
}
