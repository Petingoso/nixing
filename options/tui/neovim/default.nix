{
  lib,
  pkgs,
  config,
  ...
}: {
  options.mystuff.programs = {
    neovim-config.enable = lib.mkEnableOption "neovim-config";
  };
  config = lib.mkIf config.mystuff.programs.neovim-config.enable {
    home-manager.users.${config.mystuff.other.system.username} = {
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
          java-language-server
        ];
      };

      home.file."./.config/nvim" = {
        source = ./conf;
        recursive = true;
      };
    };
  };
}
