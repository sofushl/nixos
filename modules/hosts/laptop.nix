{ self, inputs, ... }:
let
  userconf = import ../../lib/sofushl.nix;
  laptops = import ../../lib/laptops.nix;
  resolved = builtins.mapAttrs (_: h: laptops.default // h) laptops.hosts;
  sshkeys = import ../../lib/sshkeys.nix;
  secrets =
    if builtins.pathExists /etc/nixos/secrets.nix then
      import /etc/nixos/secrets.nix
    else
      {
        edupass = "";
        networks = { };
      };
in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    hostname: sysconf:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        userconf = sysconf // userconf // sshkeys // secrets;
      };

      modules =
        with self.nixosModules;
        [
          base
          user
          disko
          preservation
          develop
          openssh
          hardware
          desktop

          # Development libraries
          icedDev
          micropython
          javaWithFx

          # Services
          networkmanager
          keyd

          {
            home-manager.users.${userconf.username}.imports = with self.homeModules; [
              firefox
              rclone
              obsidian
            ];

            preservation.preserveAt."/persistent".directories = [
              "/var/lib/bluetooth"
            ];

            preservation.preserveAt."/persistent".users.${userconf.username} = {
              directories = [
                "Downloads"
                ".config/mozilla"
                ".config/discord"
                ".config/Element"
                ".config/spotify"
                ".config/onlyoffice"
                ".local/state/onlyoffice"
                ".local/share/PrismLauncher/"
                ".claude"
              ];

              files = [
                ".config/gh/hosts.yml"
                ".config/rclone/nextcloud.pass"
                ".claude.json"
              ];
            };

            powerManagement.cpuFreqGovernor = "powersave";
          }
        ]
        ++ map (n: self.nixosModules.${n}) sysconf.modules;
    }
  ) resolved;
}
