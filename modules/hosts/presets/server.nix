{ self, ... }:

{
  flake.nixosModules.serverPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        server
        disko
        preservation

        develop

        nextcloudServer
        dnsUpdater
        gitService
        ollama
      ];

      home-manager.users.${userconf.username}.imports = with self.homeModules; [
        fastfetch
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

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      powerManagement.cpuFreqGovernor = "performance";
    };
}
