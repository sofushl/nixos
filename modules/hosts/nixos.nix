{ self, inputs, ... }:
let
  hosts = import ../../lib/hosts.nix;
  resolved = builtins.mapAttrs (_: h: hosts.default // h) hosts.hosts;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  stablepkgs = import inputs.stablepkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.cudaSupport = true;
  };
  serverconf = import ../../lib/server.nix { inherit stablepkgs; };
  secrets =
    if builtins.pathExists /etc/nixos/secrets.nix then
      import /etc/nixos/secrets.nix
    else
      {
        dnsUpdateLinks = [ ];
        secretServices = [ ];
      };

in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    hostname: sysconf:
    inputs.nixpkgs.lib.nixosSystem {
      system = sysconf.system;

      specialArgs = {
        inherit inputs stablepkgs;
        userconf = sysconf // theme // sshkeys // resolvehome.${sysconf.home} // serverconf // secrets;
      };

      modules = [ self.nixosModules.${sysconf.host} ];
    }
  ) resolved;
}
