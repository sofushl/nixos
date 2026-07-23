{ self, ... }:

{
  flake.nixosModules.serverPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        server

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
        "/var/lib/nextcloud"
        "/var/www"
        "/var/lib/ollama"
        "/var/lib/open-webui"
      ];

      preservation.preserveAt."/persistent".files = [
        "/etc/searx.env"
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = userconf.state;

      powerManagement.cpuFreqGovernor = "powersave";
    };
}
