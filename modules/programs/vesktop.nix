# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.vesktop =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.file.".config/vesktop/state.json".text = ''{"firstLaunch": false}'';

      programs.vesktop = {
        enable = true;
        package = pkgs.vesktop;

        settings = {
          appBadge = false;
          arRPC = true;
          checkUpdates = false;
          customTitleBar = false;
          disableMinSize = true;
          minimizeToTray = true;
          tray = true;
          enableSplashScreen = false;
          splashBackground = "#000000";
          splashColor = "#ffffff";
          splashTheming = true;
          staticTitle = true;
          hardwareAcceleration = true;
          discordBranch = "stable";
        };

        vencord = {
          useSystem = true;

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
              FakeNitro = {
                enabled = true;
                enableStreamQualityBypass = false;
              };
              MessageClickActions = {
                enabled = true;
                enableDeleteOnClick = false;
              };
              FriendsSince.enabled = true;
              ShowHiddenChannels.enabled = true;
              ViewRaw.enabled = true;
              MessageLinkEmbeds.enabled = true;
              NoTypingAnimation.enabled = true;
              FixCodeblockGap.enabled = true;
              CopyUserURLs.enabled = true;
              ServerInfo.enabled = true;
              ImageZoom.enabled = true;
              ReplyTimestamp.enabled = true;
              BetterSettings.enabled = true;
              CallTimer.enabled = true;
              ClearURLs.enabled = true;
              ReverseImageSearch.enabled = true;
              WhoReacted.enabled = true;
              SpotifyControls.enabled = true;
              PinDMs.enabled = true;
              FavoriteGifSearch.enabled = true;
              PlatformIndicators.enabled = true;
              NormalizeMessageLinks.enabled = true;
              BiggerStreamPreview.enabled = true;
              SilentTyping.enabled = true;
              ReadAllNotificationsButton.enabled = true;
              GifPaste.enabled = true;
              OpenInApp.enabled = true;
              ShowConnections.enabled = true;
            };
          };
        };
      };

      systemd.user.services.vesktop = {
        Unit = {
          Description = "Vesktop";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service.ExecStart = "${lib.getExe pkgs.vesktop} --start-minimized --password-store=gnome-libsecret";
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
