{
  config,
  lib,
  pkgs,
  ...
}:{
  options.mystuff.programs = {
    firefox-config.enable = lib.mkEnableOption "firefox-config";
  };

  config = lib.mkIf config.mystuff.programs.firefox-config.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
      xdg.configFile."firefox/treestyle-tab.json".source = ./tst.json; ## source manually in extensions
      xdg.configFile."firefox/tabnine.json".source = ./tab-nine.json; ## source manually in extensions
      programs.firefox = {
        enable = true;

        package = pkgs.wrapFirefox pkgs.firefox-esr-128-unwrapped {
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
                    template = "https://search.rhscz.eu/preferences?preferences=eJx1WMuS6zYO_Zp4o4prMpmqVBZeTSXzA9mrIBKWcEURuiRlt_rrB9DDIq3uRbtNgABBPA5AG0jYciCMtxY9BnAXB76doMUbOFmwAYc39BeYEhseRocJb3Yyvf61fLnDgwz7OmBk98Bwu9Ag0vUY-GO-_RMmvAyYOra3__31zyXCHSNCMN3tX5fU4YC3SKr0IvKTS7EWVR6fdYLm9je4iBfLdChnkOWVQ3tZxeqYZrHPQugvBn3CUIOj1g_yfZMH-wBv0NbbuSv154RhrsnXiZIoWOwkfydPSZSawM6txFVKzTKrr2ZR5NCkld1x6nGON4t3EPsvU3D1ncMAKZFvb2PAlOaLpQiNExvQt-TF2X-20NZ1ZEPgqgEtwS___q_crcEqip_7ul68GEtq9SCLXNfLv3ceTJaEN0yRjLLcKCdVjvz0UY1gelUnapPyRnFdJZ8qGrCu7-TWszxILC3s-6IYsuWFLBtypH-ZAQ2lRvIA0ybRjE0hkSy17aF_uenVGHO1mGkxjid7dxAQKBc3o_jvjgElftsBEpkYhSjOM6T0lfa0D5KsyWRnHN-W1erSzLVKlGQTkn6qJgkfYS5nET8lqV5utRgTJBIRlvQNSrFtJdHXzCH2MRcW-2a525ZCOUMsJnvoeFJPFhIUJ79qbA17zByW8Qr7M_oTQZUfZ6xBH2CU7fKpVgz8g0YNybHrt4_MP3IpmzpIg9RpTg4oScf39JSIVZaCVIPWxRqheyDfE5hcYJ6zy7ZIn50UYUaRGoRmjzBbbDC021J4KCnDw75mtpInNhdnbuVqo4NZkzoe-ZZzBpYUyZ0oNYpB60_xK0-LDpoA-rEd2Un1YFgdvRLw45WOoiRetfCWNQ22OQyjoZ1Cppg8ZOeTl6_EU_yatmfcD4odHzqlBAVTAvjo5Og8YRw3MeE17FYK7IIZwe9L_uyK6hqeQ-Nygh93J7OdI-YVyiN6PRk0zLspSpRDkEtSwJGzGKzYQ3GHCCnpc0G8iOciPVh7GXwlVpTBODUCMI_twIDWUjqhbaC2S5UFzhUGTklaB0tuMGYptp4yzJFKnwuwmynG6zhLi9s9bcDaWVN2mAQU9roY6deOHZ7oq2rN-ko_XtQBfCJTRSNSEHK8EwQKadQmm1mSuJ85seRKryHfvZ_Ui6IDpmJzRt18lorMfVIz5wIKUA1zH9-JPycuPaLEyFMwZ-qIZqnAb8jHBZUs3T4uTip3P3h-u_iT3T3AIP2ue8NPiz6P4KeHoch__oHYnynnFNzoRY4tcDKS43Sc4eGhiJul09TMLQ57RY6IIU1NXlhLNop4r_3riU3GmsEU19f12bYwSRXnGp24LkrR5bQnf1DPXoqiirNnPyueH57BPpSXW0mns1byqRtFgSOTclPjo1UUyEQfTHaZRTZXaCwH6ZnFBadhcBm-CNw8SoSj5oC3Ncm6KR2NoYCGvr22vMPABX05gIH3ECutPHrkA9DYVwOFwCGjKb6sc5Ravc9GQaozH9PCBz3yJG7AWwPDeCC5Sm_tNh-qfPu-Pnt-oRYhWiinUCj-auXk7dp0eO9Z8XZ3rIw5OlPN5aDzIEEcuVYmalk7X9VNe3M-BoxvRpWT5TIG41xEEdM8sHQTn-Xg3QbWgWj3-d2R6fPWKeKUd8VWUXrvujIjHCauPT8_cJsCTqZt9MKtG-3k2I3-BRp323nL4b2YDTHrfg6HYa52zF9xruxD644pYviOJ-00fcdTzeKKL9hrt67UDZEyiz5_fTXyl5HbXr6LPi-lG3M3SaTaR5GzA8i7wbL_xuoXu4PYSav5Yod9TSX0sUz_R2T9DJC9GECGSdwnMU1vkHlTZ-WIqWgaO0-avyQPbMN4yRekQkwy_e4j8GgVjY9No7zntI9vXNIXJca8JEYt4SwxlvV1Mf64w0g6FzaQ-XhkQYMo1WB1eNzzXowdVF1mwTzuEPPzKQWZ-30hlPm6kk6pvZJPWRxAhsuqkddHzB81URoZ7EPZAes8CYKVwZHRw_QsCHN3_DxeiVMz-TTtwDyNGKb4Cpo83cnKAyGsebo7ZPJR5vLY5e8x6EoQXwjlhWee3lroi_J6owE5gRjNgGzbg4bi7axoXGgWgooUI65u0hKTXLqenJwzT67OmW9P85y1eONwiiWTPtkX8DVItx7kfVW9pn6bs3_7_fc_Pg4NTw7WU39cQWAy6UNO4_FWhk9wrpMe6_NLpRSu5N-68PnyK_l07ZVcdqr0n_0ngOOHkNFN0ojjTbPu47qtrp0gnUxp27CRcxQ9awEnST0pyVc7_1qNAWcmcRSHkx6FpE3qxGOo1x-bnkHG_BM7orvX5O984shBtXRZ0585YXk71vqzUJAoivkXmdQFiW7_B28sXAE=?q={searchTerms}";
                  }
                ];
                iconUpdateURL = "https://searx.be/static/themes/oscar/img/favicon.png";
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
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nw"];
              };
              "Wikipedia (en)".metaData.alias = "@wiki";
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
                rev = "f906f7f3b41fe3f6aaa744980431f4fdcd086379"; #128.0
              }
              + "/user.js")}\n"

            ''
                user_pref("browser.search.suggest.enabled",true);
                user_pref("privacy.cpd.history" , false);
              user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
                user_pref("privacy.clearOnShutdown.history" , false);
                user_pref("browser.privatebrowsing.autostart" , false);
                user_pref("places.history.enabled" , true);
                user_pref("keyword.enabled" , true);
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
