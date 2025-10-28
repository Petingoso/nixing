{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    neovim
    bat
    lynx
    nh
    alejandra
    ranger
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
