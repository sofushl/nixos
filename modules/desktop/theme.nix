# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.theme =
    { pkgs, userconf, ... }:
    let
      mono = "JetBrainsMono Nerd Font Mono";
      sans = "Inter";
      serif = "Noto Serif";
      emoji = "Noto Color Emoji";
      c = userconf.theme;
    in
    {
      home = {
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          inter
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
        ];

        pointerCursor = {
          enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 20;

          gtk.enable = true;
          x11.enable = true;
          dotIcons.enable = true;
        };
      };

      gtk =
        let
          gtkConf = {
            extraConfig.gtk-application-prefer-dark-theme = true;

            extraCss = ''
              @define-color accent_color ${c.primary}; 
              @define-color accent_bg_color ${c.bg.selected};
              @define-color accent_fg_color ${c.text.primary};
            '';
          };
        in
        {
          enable = true;
          colorScheme = "dark";

          gtk3 = gtkConf;
          gtk4 = gtkConf;
        };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            accent-color = "red";
          };
        };
      };

      fonts.fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [ mono ];
          sansSerif = [ sans ];
          serif = [ serif ];
          emoji = [ emoji ];
        };

        antialiasing = true;
      };
    };
}
