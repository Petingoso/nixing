{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mystuff.programs.git;
  inherit (config.mystuff.other.system) username;

  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrs listOf nullOr str;

  delta = getExe pkgs.delta;
in {
  options.mystuff.programs.git = {
    enable = mkEnableOption "git";
    userName = mkOption {
      type = str;
      default = "";
      description = "git username";
    };
    userEmail = mkOption {
      type = str;
      default = "";
      description = "git email";
    };
    signingKey = mkOption {
      type = nullOr str;
      default = null;
      description = "git commit signing key";
    };
    editor = mkOption {
      type = str;
      default = "$EDITOR";
      description = "commit message editor";
    };
    defaultBranch = mkOption {
      type = str;
      default = "main";
      description = "default git branch";
    };
    includes = mkOption {
      type = listOf attrs;
      default = [];
      description = "passthrough to the hm module";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail includes;
        extraConfig = {
          core = {
            inherit (cfg) editor;
            pager = "${delta}";
          };
          init.defaultBranch = cfg.defaultBranch;
          push.autoSetupRemote = true;
          commit = {
            verbose = true;
            gpgsign = cfg.signingKey != null;
          };
          gpg.format = "ssh";
          user.signingkey = mkIf (cfg.signingKey != null) "key::${cfg.signingKey}";
          interactive.diffFilter = "${delta} --color-only";
          # diff.algorithm = "histogram";
          # transfer.fsckobjects = true;
          # fetch.fsckobjects = true;
          # receive.fsckobjects = true;
        };
      };
    };
  };
}
