{
  flake.nixosModules.gaming =
    { pkgs, userconf, ... }:

    {
      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".steam"
        ".local/share/Steam/"

        ".config/heroic"
        ".local/state/Heroic"

        ".local/share/PrismLauncher/"

        "Gaming"
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable = true;
      };

      hardware.graphics.enable32Bit = true;

      environment.systemPackages = with pkgs; [
        protonup-qt
        wine
        prismlauncher
        heroic
      ];
    };
}
