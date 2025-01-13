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
          gcc
          unzip
          hurl
          jq
          nodePackages.browser-sync
          yarn
          nodejs
          stylua
          beautysh
          clang-tools
          prettierd
          ripgrep
          lua-language-server
          vscode-extensions.ms-vscode.cpptools
          vscode-langservers-extracted
          python3Packages.jedi-language-server
          phpactor
          nil
        ];
      };

      home.file."./.config/nvim" = {
        source = ./conf;
        recursive = true;
      };
    };
  };
}
