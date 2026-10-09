{ self, ... }:
{
  flake.nixosModules.T2000 = { userconf, ... }: {

    imports = with self.nixosModules; [
      base
      environment
      home
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
      docker
    ];

    users.users.${userconf.username}.linger = true;

    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      headless
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
        "Documents"
        ".local/share/docker"
      ];

      files = [
        ".config/gh/hosts.yml"
        ".claude.json"
      ];
    };

    powerManagement.cpuFreqGovernor = "performance";
  };
}
