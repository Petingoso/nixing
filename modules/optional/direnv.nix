{config, ...}: {
  config = {
    programs.direnv = {
      enable = true;
      loadInNixShell = true;
    };
  };
}
