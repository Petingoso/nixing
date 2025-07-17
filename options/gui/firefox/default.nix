{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mystuff.programs = {
    firefox-config.enable = lib.mkEnableOption "firefox-config";
  };

  config = lib.mkIf config.mystuff.programs.firefox-config.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
      xdg.configFile."firefox/treestyle-tab.json".source = ./tst.json; ## source manually in extensions
      xdg.configFile."firefox/tabnine.json".source = ./tab-nine.json; ## source manually in extensions
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
            ExtensionSettings = let
              extension = shortId: uuid: {
                name = uuid;
                value = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortId}/latest.xpi";
                  installation_mode = "normal_installed";
                };
              };
            in
              builtins.listToAttrs [
                (extension "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
                (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
                (extension "buster-captcha-solver" "{e58d3966-3d76-4cd9-8552-1582fbc800c1}")
                (extension "chameleon-ext" "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}")
                (extension "cookie-editor" "{c3c10168-4186-445c-9c5b-63f12b8e2c87}")
                (extension "darkreader" "addon@darkreader.org")
                (extension "noscript" "{73a6fe31-595d-460b-a920-fcc0f8843232}")
                (extension "prettier-lichess" "{8ad4bea8-ad8d-4e98-b434-a76065dee6cb}")
                (extension "s3_translator" "s3@translator")
                (extension "skip-redirect" "skipredirect@sblask")
                (extension "smart-referer" "smart-referer@meh.paranoid.pk")
                (extension "tab-session-manager" "Tab-Session-Manager@sienori")
                (extension "tampermonkey" "firefox@tampermonkey.net")
                (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")
                (extension "tst-search" "@tst-search")
                (extension "tst-fade-old-tabs" "tst_fade_old_tabs@emvaized.com")
                (extension "ublock-origin" "uBlock0@raymondhill.net")
                (extension "tab-nine" "extension@tab-nine.xsfs.xyz")
              ];
            # To add additional extensions, find it on addons.mozilla.org, find
            # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
            # Then, download the XPI by filling it in to the install_url template, unzip it,
            # run `jq .browser_specific_settings.gecko.id manifest.json`
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
            "${builtins.readFile (fetchGit {
                url = "https://github.com/arkenfox/user.js";
                rev = "3d76c74c80485931425464fec0e59d6cb461677a"; #135.0
              }
              + "/user.js")}\n"

            ''
                user_pref("browser.search.suggest.enabled",true);
                user_pref("privacy.cpd.history" , false);
                user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);
                user_pref("privacy.clearOnShutdown_v2.downloads", false);
                user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false);
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
            ''
          ];
          userChrome = ''
            #TabsToolbar {
              visibility: collapse;
            }
          '';

          userContent = "";
        };
      };
    };
  };
}
