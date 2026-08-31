{ self, inputs, ... }:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.username;
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
  theme = import ../../lib/theme.nix;
in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    hostname: sysconf:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        userconf = sysconf // resolvehome.${sysconf.username} // theme // sshkeys // secrets;
      };

      modules =
        with self.nixosModules;
        [
          base
          environment
          user
          disko
          preservation
          openssh
          desktop

          # Development libraries
          icedDev
          python
          javaWithFx
          node
          rust
          c

          # Services
          networkmanager
          keyd

          {
            home-manager.users.${userconf.username}.imports = with self.homeModules; [
              firefox
              rclone
              obsidian
              develop
            ];

            preservation.preserveAt."/persistent".directories = [
              "/var/lib/bluetooth"
            ];

            preservation.preserveAt."/persistent".users.${userconf.username} = {
              directories = [
                "Desktop"
                "Documents"
                "Downloads"
                "Public"

                ".config/mozilla"
                ".config/discord"
                ".config/Element"
                ".config/spotify"

                ".config/onlyoffice"
                ".local/state/onlyoffice"

                ".config/JetBrains"
                ".local/share/JetBrains"
                ".config/Code"
                ".vscode"
                ".m2"

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
