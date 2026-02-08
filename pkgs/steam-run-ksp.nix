{
  steam,
  runCommandLocal,
}: let
  steam-run =
    (steam.override {
      extraPkgs = pkgs: [pkgs.corefonts pkgs.vista-fonts];
    })
    .run;
in
  runCommandLocal "steam-run-ksp" {} ''
    mkdir -p $out/bin
    ln -s ${steam-run}/bin/steam-run $out/bin/steam-run-ksp
  ''
