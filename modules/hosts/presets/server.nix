{ self, ... }:

{
  flake.nixosModules.serverPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        default
        boot
        server

        nextcloudServer
        dnsUpdater
        gitService
        ollama
      ];

      preservation.preserveAt."/persistent".directories = [
        "/var/lib/"
        "/var/www"
        "/var/log"
      ];

      preservation.preserveAt."/persistent".files = [
        "/etc/searx.env"
      ];

      preservation.preserveAt."/persistent".users.${userconf.username} = {
        files = [
          ".config/gh/hosts.yml"
        ];
      };

      powerManagement.cpuFreqGovernor = "performance";
    };
}
