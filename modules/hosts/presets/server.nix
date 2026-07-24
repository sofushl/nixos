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
        dev
        git
        yazi
        neovim
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

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      powerManagement.cpuFreqGovernor = "performance";
    };
}
