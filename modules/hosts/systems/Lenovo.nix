{ self, ... }:

{
  flake.nixosModules.Lenovo = { pkgs, userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      hardware
      user
      disko
      preservation
      niri
      desktop

      eduroam
      openssh
      keyd
    ];

    preservation.preserveAt."/persistent" = {
      directories = [ "opt" ];
      users.${userconf.username} = {
        directories = [
          "Downloads"

          ".librewolf"
          ".config/discord"
          ".config/Element"
          ".config/spotify"
          ".cache/spotify"

          ".local/state/wireplumber"

          ".config/onlyoffice"
          ".local/state/onlyoffice"

          ".claude"
        ];

        files = [
          ".config/gh/hosts.yml"
          ".claude.json"
        ];
      };
    };

    powerManagement.cpuFreqGovernor = "powersave";
  };

}
