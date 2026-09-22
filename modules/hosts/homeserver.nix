{ self, inputs, ... }:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.headless;
  sysconf = import ../../lib/T2000.nix;
  pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
  stablepkgs = import inputs.stablepkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
  serverconf = import ../../lib/server.nix { inherit pkgs; };
  sshkeys = import ../../lib/sshkeys.nix;
  secrets =
    if builtins.pathExists /etc/nixos/secrets.nix then
      import /etc/nixos/secrets.nix
    else
      {
        dnsUpdateLinks = [ ];
        secretServices = [ ];
      };
  theme = import ../../lib/theme.nix;
in
{
  flake.nixosConfigurations.T2000 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs stablepkgs;
      userconf = homeconf // sysconf // sshkeys // theme // secrets // serverconf;
    };

    modules = with self.nixosModules; [
      base
      environment
      user
      disko
      preservation

      hardware
      nvidia

      server
      openssh
      keyring

      nextcloudServer
      dnsUpdater
      gitService
      minecraftServer

      {
        home-manager.users.${homeconf.username}.imports = with self.homeModules; [
          develop
          fonts
        ];

        preservation.preserveAt."/persistent".directories = [
          "/var/www"
          "/var/log"
        ];

        preservation.preserveAt."/persistent".files = [
          "/etc/searx.env"
        ];

        preservation.preserveAt."/persistent".users.${homeconf.username} = {
          directories = [
            ".claude"
          ];

          files = [
            ".config/gh/hosts.yml"
            ".claude.json"
          ];
        };

        powerManagement.cpuFreqGovernor = "performance";
      }
    ];
  };
}
