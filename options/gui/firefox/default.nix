{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.programs.firefox-config;
  inherit (config.custom) username enableHM;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options.custom.programs = {
    #NOTE: Needs home manager
    firefox-config.enable = mkEnableOption "firefox-config";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      config,
      mozid,
      ...
    }:
      mkIf enableHM {
        # xdg.configFile."firefox/treestyle-tab.json".source = ./tst.json; ## source manually in extensions
        xdg.configFile."firefox/tabnine.json".source = ./tab-nine.json; # # source manually in extensions
        programs.firefox = {
          enable = true;

          package = pkgs.wrapFirefox pkgs.firefox-esr-140-unwrapped {
            extraPolicies = {
              CaptivePortal = false;
              DisableFirefoxStudies = true;
              DisablePocket = true;
              DisableTelemetry = true;
              DisableFirefoxAccounts = false;
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
              OfferToSaveLoginsDefault = false;
              PasswordManagerEnabled = false;
              WarnOnClose = true;
              FirefoxHome = {
                Search = true;
                Pocket = false;
                Snippets = false;
                TopSites = false;
                Highlights = false;
              };
              UserMessaging = {
                ExtensionRecommendations = false;
                SkipOnboarding = true;
              };
              ExtensionSettings =
                {
                  "*".installation_mode = "blocked";

                  "tsukihi@lanraragi.extension" = {
                    install_url = "https://github.com/Difegue/Tsukihi/releases/download/v2.0/Tsukihi-2.0.xpi";
                    installation_mode = "normal_installed";
                  };
                }
                // (
                  let
                    extensionIds = import ./firefox-extension-ids.nix;
                  in
                    builtins.listToAttrs (
                      # for each short id in extensionIds
                      # create an element in the list that is a set like this
                      # then use list to Attrs
                      builtins.map (shortId: {
                        name = extensionIds.${shortId};
                        value = {
                          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortId}/latest.xpi";
                          installation_mode = "normal_installed";
                        };
                      }) (builtins.attrNames extensionIds)
                    )
                );
            };
          };
          profiles.Default = {
            search = {
              force = true;
              default = "SearX";
              engines = {
                "SearX" = {
                  urls = [
                    {
                      template = "https://search.undertale.uk/search?q={searchTerms}";
                    }
                  ];
                  icon = "https://search.undertale.uk/static/themes/oscar/img/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                };
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = ["@np"];
                };
                "NixOS Wiki" = {
                  urls = [
                    {
                      template = "https://nixos.wiki/index.php?search={searchTerms}";
                    }
                  ];
                  icon = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = ["@nw"];
                };
                "wikipedia".metaData.alias = "@wiki";
              };
            };
            settings = {
              "General.smoothScroll" = true;
              "media.autoplay.enabled.user-gestures-needed" = false;
              "ui.systemUsesDarkTheme" = 1;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "full-screen-api.ignore-widgets" = true;
              "media.ffmpeg.vaapi.enabled" = true;
              "media.rdd-vpx.enabled" = true;
            };
            extraConfig = lib.strings.concatStrings [
              "${
                builtins.readFile (
                  fetchGit {
                    url = "https://github.com/arkenfox/user.js";
                    rev = "0f14e030b3a9391e761c03ce3c260730a78a4db6"; # 140.1
                  }
                  + "/user.js"
                )
              }\n"

              ''
                 # user_pref("browser.search.suggest.enabled",true);




                 user_pref("privacy.cpd.history" , false);

                 user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
                 user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);
                 user_pref("privacy.clearOnShutdown_v2.downloads", false);

                 user_pref("privacy.clearHistory.historyFormDataAndDownloads", false);
                 user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false);

                 user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false);
                 user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false);

                 user_pref("browser.privatebrowsing.autostart" , false);
                 user_pref("places.history.enabled" , true);

                 user_pref("keyword.enabled" , true);
                user_pref("browser.newtabpage.activity-stream.discoverystream.reportAds.enabled", false);
                user_pref("browser.newtabpage.activity-stream.telemetry.privatePing.enabled", false);
                user_pref("extensions.dataCollectionPermissions.enabled", false);
                user_pref("privacy.antitracking.isolateContentScriptResources", false);
                user_pref("privacy.baselineFingerprintingProtection", true);
                user_pref("toolkit.aboutLogging.uploadProfileToCloud", false);

                user_pref("browser.tabs.min_inactive_duration_before_unload", 600); # unload tabs after 10 minutes
                user_pref("sidebar.verticalTabs", true); # vertical tabs
              ''
            ];
            # userChrome = ''
            #   #TabsToolbar {
            #     visibility: collapse;
            #   }
            # '';

            # userContent = "";
          };
        };
      };
  };
}
