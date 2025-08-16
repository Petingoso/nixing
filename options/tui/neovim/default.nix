{
  lib,
  pkgs,
  config,
  ...
}: let
    inherit (config.custom) username enableHM;
    cfg = config.custom.programs;
in
{
  options.custom.programs = {
    #NOTE: needs Home manager
    neovim-config.enable = lib.mkEnableOption "neovim-config";
  };
  config = lib.mkIf cfg.neovim-config.enable {
    home-manager.users.${username} = lib.mkIf enableHM{
      programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [
          # C
          gcc

          # utils
          unzip
          hurl
          jq
          ripgrep

          # browsersync
          nodePackages.browser-sync
          yarn
          nodejs

          # formatters
          stylua
          clang-tools
          shfmt
          prettierd
          typstyle

          # LSPs
          lua-language-server
          vscode-langservers-extracted
          vscode-extensions.ms-vscode.cpptools
          python3Packages.python-lsp-server
          python3Packages.jedi-language-server
          phpactor
          tinymist
          nil
          jdt-language-server
        ];
      };

      home.file."./.config/nvim" = {
        source = ./conf;
        recursive = true;
      };
    };
  };
}
