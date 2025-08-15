{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.mystuff.programs.zsh;
  inherit (config.custom) username enableHM;
in {
  options.custom.programs = {
    zsh.enable = lib.mkEnableOption "zsh";
    zsh.zinit.enable = lib.mkEnableOption "zsh.zinit";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.zsh.enable = true;
      users.users.${username}.shell = pkgs.zsh;

      home-manager.users.${username} = lib.mkIf enableHM {
        home.packages = [
          pkgs.eza
          pkgs.fzf
        ];

        # programs.zsh.enable = true;

        home.file.".zshrc".text = lib.strings.concatStrings [
          (lib.optionalString cfg.zinit.enable (builtins.readFile ./zinit))
          (builtins.readFile ./zshrc)
        ];

        home.file.".p10k.zsh" = lib.mkIf cfg.zinit.enable {
          source = ./p10k.zsh;
        };
      };
    })
  ];
}
