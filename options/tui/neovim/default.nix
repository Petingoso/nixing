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
      home.packages = with pkgs; [nil stylua beautysh clang-tools prettierd ripgrep lua-language-server vscode-extensions.ms-vscode.cpptools vscode-langservers-extracted python3Packages.jedi-language-server phpactor];

      programs.neovim = {
        enable = true;
        extraPackages = [pkgs.gcc pkgs.unzip pkgs.hurl pkgs.jq pkgs.nodePackages.browser-sync];
      };

      home.file."./.config/nvim" = {
        source = ./conf;
        recursive = true;
      };
    };
  };
}
