{
  lib,
  enableHM,
  ...
}: {
  imports =
    lib.optionals enableHM [
      ./bootstrap.nix
      ./firefox
      ./kitty
      ./noctalia
      ./vesktop
      ./vscodium
      ./mpv.nix
    ]
    ++ [
    ];
}
