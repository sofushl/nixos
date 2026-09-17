{ self, inputs, ... }:
let
  homes = import ../../lib/homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  laptops = import ../../lib/laptops.nix;
  resolved = builtins.mapAttrs (_: h: laptops.default // h) laptops.hosts;
  sshkeys = import ../../lib/sshkeys.nix;
  theme = import ../../lib/theme.nix;
in
{
  flake.nixosConfigurations = builtins.mapAttrs (
    hostname: sysconf:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        userconf = sysconf // resolvehome.laptop // theme // sshkeys;
      };

      modules =
        with self.nixosModules;
        [
          base
          environment
          hardware
          user
          disko
          preservation
          desktop

          eduroam
          openssh
          bluetooth
          keyring
          keyd

          # Development libraries
          python
          javaWithFx
          node
          rustWASM
          clangGTK
          mplab

          {
            home-manager.users.${resolvehome.laptop.username}.imports = with self.homeModules; [
              firefox
              rclone
              obsidian
              develop
              vscodium
            ];

            preservation.preserveAt."/persistent" = {
              directories = [ "opt" ];
              users.${sysconf.username} = {
                directories = [
                  "Downloads"
                  "Public"

                  ".config/mozilla"
                  ".config/discord"
                  ".config/Element"
                  ".config/spotify"
                  ".cache/spotify"

                  ".config/onlyoffice"
                  ".local/state/onlyoffice"

                  ".config/JetBrains"
                  ".local/share/JetBrains"
                  ".m2"

                  ".config/VSCodium"
                  ".vscode-oss-shared"

                  ".mplab"
                  ".mplabcomm"
                  ".mchp_packs"

                  ".claude"
                ];

                files = [
                  ".config/gh/hosts.yml"
                  ".config/rclone/nextcloud.pass"
                  ".claude.json"
                ];
              };
            };

            powerManagement.cpuFreqGovernor = "powersave";
          }
        ]
        ++ map (n: self.nixosModules.${n}) sysconf.modules;
    }
  ) resolved;
}
