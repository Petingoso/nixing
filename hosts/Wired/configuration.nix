{
  config,
  pkgs,
  ...
}: let
  inherit (config.custom) username;
in {
  programs.kdeconnect.enable = true;

  custom = {
    username = "petnix";
    programs = {
      git = {
        enable = true;
        defaultBranch = "master";
      };
      zsh = {
        enable = true;
        zinit.enable = true;
      };
      nh = {
        enable = true;
        flake = "/home/${username}/flake";
      };

      quickshell.enable = true;
      firefox-config.enable = true;
      kitty.enable = true;
      mpv.enable = true;
      neovim-config.enable = true;
      vscode.enable = true;
      ranger.enable = true;
      vesktop.enable = true;
    };
    services = {
      greetd.enable = true;
      #TODO: modularize?
      greetd.greeter = "tuigreet";
      greetd.cage = false;
      networkmanager.enable = true;
      networkmanager.powersave = true;
    };
  };

  age.identityPaths = ["/home/${username}/.ssh/id_ed25519"];
  age.secrets.test.file = ../../secrets/test.age;
  system.stateVersion = "23.11";
}
