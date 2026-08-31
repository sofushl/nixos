{ self, inputs, ... }:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.${sysconf.username};
  sysconf = import ../../lib/T2000.nix;
  pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
  serverconf = import ../../lib/server.nix { inherit pkgs; };
  sshkeys = import ../../lib/sshkeys.nix;
  secrets = import /etc/nixos/secrets.nix;
  theme = import ../../lib/theme.nix;
in
{
  flake.nixosConfigurations.T2000 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
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

      nextcloudServer
      dnsUpdater
      gitService
      ollama

      {
        home-manager.users.${userconf.username}.imports = with self.homeModules; [
          develop
        ];

        preservation.preserveAt."/persistent".directories = [
          "/var/lib/"
          "/var/www"
          "/var/log"
        ];

        preservation.preserveAt."/persistent".files = [
          "/etc/searx.env"
        ];

        preservation.preserveAt."/persistent".users.${userconf.username} = {
          directories = [
            ".local/share/opencode"
            ".local/state/opencode"
            ".config/opencode"
          ];

          files = [
            ".config/gh/hosts.yml"
          ];
        };

        powerManagement.cpuFreqGovernor = "performance";
      }
    ];
  };
}
