{inputs, ...}: let
  inherit (inputs) self;
  inherit (self) lib;

  inherit (lib.attrsets) listToAttrs;
  inherit (lib.path) append;

  createHost' = extraModules: hostDir:
    lib.nixosSystem {
      system = null;
      specialArgs = {
        inherit lib inputs self;
      };
      modules =
        [
          hostDir
          ../options
          ../modules/core
        ]
        ++ extraModules;
    };

  createHost = createHost' [];
  createDesktop = createHost' [../modules/desktop];
  createServer = createHost' [];

  createHosts = hosts:
    listToAttrs (map (host: let
        createFn =
          {
            desktop = createDesktop;
            server = createServer;
            generic = createHost;
          }
          ."${host.type}";
        path' = append host.dir "system.nix";
        cfg = (import path') {
          inherit inputs;
        };
      in {
        name = cfg.mystuff.other.system.hostname;
        value = createFn host.dir;
      })
      hosts);
in
  createHosts [
    {
      dir = ./Wired;
      type = "desktop";
    }
  ]
