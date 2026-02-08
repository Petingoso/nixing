{
  lib,
  pkgs,
  config,
  ...
}: {
  options.custom.programs = {
    neovim-config.enable = lib.mkEnableOption "neovim-config";
  };
  config = lib.mkIf config.custom.programs.neovim-config.enable {
    home-manager.users.${config.custom.username} = {
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
          # nodePackages.browser-sync
          yarn
          nodejs

          # formatters
          stylua
          ccls
          clang-tools
          shfmt
          prettierd
          typstyle

          # LSPs
          lua-language-server
          vscode-langservers-extracted
          # vscode-extensions.ms-vscode.cpptools
          black
          basedpyright
          phpactor
          tinymist
          nil
          java-language-server
          rust-analyzer
        ];
      };

      home.file."./.config/nvim" = {
        source = ./conf;
        recursive = true;
      };
    };
  };
}
