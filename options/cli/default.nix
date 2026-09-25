{
  lib,
  enableHM,
  ...
}: {
  imports =
    lib.optionals enableHM [
      ./git.nix
      ./zsh
    ]
    ++ [
      ./nh.nix
    ];
}
