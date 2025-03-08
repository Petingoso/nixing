{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}: let
  cfg = config.mystuff.programs.vscode;
  inherit (config.mystuff.other.system) username;

  inherit (lib.attrsets) attrValues;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr str;
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system};
in {
  options.mystuff.programs.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    # to acess the home manager "config" change that param
    home-manager.users.${username} = {config, ...}: {
      # makes it runtime editable, this is a crime
      xdg.configFile."VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/flake/options/gui/vscodium/settings.json";
      xdg.configFile."VSCodium/User/tasks.json".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/flake/options/gui/vscodium/tasks.json";
      xdg.configFile."VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/flake/options/gui/vscodium/keybindings.json";
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium.fhsWithPackages (ps: with ps; [gcc gnumake gdb clang-tools shfmt python3 nil]);
        extensions = with pkgs.vscode-extensions;
          [
            # LSP and formatters
            ms-vscode.cpptools
            myriad-dreamin.tinymist
            sumneko.lua
            ms-python.python
            jnoortheen.nix-ide

            xaver.clang-format
            kamadorueda.alejandra
            esbenp.prettier-vscode

            # Tools
            ms-vscode.makefile-tools
            shd101wyy.markdown-preview-enhanced
            james-yu.latex-workshop
            vspacecode.whichkey
            asvetliakov.vscode-neovim
            editorconfig.editorconfig
            arrterian.nix-env-selector
            usernamehw.errorlens
            gruntfuggly.todo-tree
            oderwat.indent-rainbow

            # Themes
            arcticicestudio.nord-visual-studio-code
            catppuccin.catppuccin-vsc
            jdinhlife.gruvbox
            enkia.tokyo-night
            mvllow.rose-pine
          ]
          ++ (with nix-vscode-extensions; [
            open-vsx.murloccra4ler.bettersearch

            open-vsx.mkhl.shfmt
            open-vsx.johnnymorganz.stylua

            open-vsx.sainnhe.everforest
            open-vsx.srcery-colors.srcery-colors
            open-vsx.ginfuru.ginfuru-better-solarized-dark-theme
          ]);
      };
    };
  };
}
