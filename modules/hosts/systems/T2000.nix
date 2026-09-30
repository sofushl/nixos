{ self, ... }:
{
  flake.nixosModules.T2000 = { userconf, ... }: {

    imports = with self.nixosModules; [
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
      tmux
    ];

    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      neovim
      yazi
      claude
      git
      bash
      fastfetch
    ];

    preservation.preserveAt."/persistent".directories = [
      "/var/www"
      "/var/log"
    ];

    preservation.preserveAt."/persistent".files = [
      "/etc/searx.env"
    ];

    preservation.preserveAt."/persistent".users.${userconf.username} = {
      directories = [
        ".claude"
      ];

      files = [
        ".config/gh/hosts.yml"
        ".claude.json"
      ];
    };

    powerManagement.cpuFreqGovernor = "performance";
  };
}
