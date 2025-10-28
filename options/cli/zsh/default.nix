{
  lib,
  pkgs,
  config,
  ...
}: {
  options.mystuff.programs = {
    zsh.enable = lib.mkEnableOption "zsh";
    zsh.zinit.enable = lib.mkEnableOption "zsh.zinit";
  };

  config = lib.mkMerge [
    (lib.mkIf config.mystuff.programs.zsh.enable {
      programs.zsh.enable = true;
      users.users.${config.mystuff.other.system.username}.shell = pkgs.zsh;

      home-manager.users.${config.mystuff.other.system.username} = {
        home.packages = [
          pkgs.eza
          pkgs.fzf
        ];

        # programs.zsh.enable = true;

        home.file.".zshrc".text = lib.strings.concatStrings [
          (lib.optionalString config.mystuff.programs.zsh.zinit.enable (builtins.readFile ./zinit))
          (builtins.readFile ./zshrc)
        ];

        home.file.".p10k.zsh" = lib.mkIf config.mystuff.programs.zsh.zinit.enable {
          source = ./p10k.zsh;
        };
      };
    })
  ];
}
