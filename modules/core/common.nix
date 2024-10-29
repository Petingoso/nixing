{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    neovim
    bat
    lynx
    nh
    alejandra
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
