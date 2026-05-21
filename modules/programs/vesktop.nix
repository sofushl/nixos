{
  flake.nixosModules.vesktop =
    { userconf, pkgs, ... }:
    {

      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".config/vesktop/sessionData"
      ];

      home-manager.users.${userconf.username} = {
        programs.vesktop = {
          enable = true;

          settings = {
            appBadge = false;
            arRPC = true;
            checkUpdates = false;
            customTitleBar = false;
            disableMinSize = true;
            minimizeToTray = false;
            tray = false;
            splashBackground = "#000000";
            splashColor = "#ffffff";
            splashTheming = true;
            staticTitle = true;
            hardwareAcceleration = true;
            discordBranch = "stable";
          };

          vencord = {

            settings = {
              autoUpdate = true;
              autoUpdateNotification = false;
              notifyAboutUpdates = true;
              disableMinSize = true;
              plugins = {
                MessageLogger = {
                  enabled = true;
                  ignoreSelf = true;
                };
                FakeNitro.enabled = true;

                FriendsSince.enabled = true;
              };
            };

            useSystem = true;

          };

        };
      };
    };
}
