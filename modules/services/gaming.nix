{
  flake.nixosModules.gaming =
    {
      pkgs,
      userconf,
      config,
      ...
    }:

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
        heroic

        (
          if config.hardware.nvidia.enabled then
            (pkgs.symlinkJoin {
              name = "prismlauncher-nvidia";
              paths = [ pkgs.prismlauncher ];
              nativeBuildInputs = [ pkgs.makeWrapper ];
              postBuild = ''
                wrapProgram $out/bin/prismlauncher \
                  --set __NV_PRIME_RENDER_OFFLOAD 1 \
                  --set __GLX_VENDOR_LIBRARY_NAME nvidia
              '';
            })
          else
            pkgs.prismlauncher
        )
      ];
    };
}
