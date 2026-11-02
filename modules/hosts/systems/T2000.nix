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
      lanzaboote

      hardware
      nvidia

      server
      openssh
      keyring
      vaultwarden

      nextcloudServer
      dnsUpdater
      gitService
      minecraftServer
      satisfactoryServer
      tmux
    ];

    preservation.preserveAt."/persistent".directories = [
      "/var/www"
      "/var/log"
      "/var/backup"
    ];

    preservation.preserveAt."/persistent".users.${userconf.username} = {
      directories = [
        ".local/share/opencode"
        ".local/state/opencode"
        ".config/opencode"

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
