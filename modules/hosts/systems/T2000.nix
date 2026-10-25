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
      satisfactoryServer
      tmux
      docker
      omniroute
    ];

    preservation.preserveAt."/persistent".directories = [
      "/var/www"
      "/var/log"
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
