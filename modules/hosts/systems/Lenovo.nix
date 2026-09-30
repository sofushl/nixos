{ self, ... }:

{
  flake.nixosModules.Lenovo = { userconf, ... }: {
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

    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      firefox
      neovim
      yazi
      git

      bash
      fonts
      fastfetch

      claude
      node
    ];

    preservation.preserveAt."/persistent" = {
      directories = [ "opt" ];
      users.${userconf.username} = {
        directories = [
          "Downloads"

          ".config/mozilla"
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
