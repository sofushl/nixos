{ inputs, ... }: {
  flake.homeModules.stylix =
    {
      userconf,
      pkgs,
      config,
      ...
    }:
    {

      imports = [ inputs.stylix.homeModules.stylix ];
      dconf.enable = true;

      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = userconf.theme-vscode.alt;

        targets = {
          firefox.profileNames = [ "default" ];

          neovim.enable = false;
          gtk.enable = false;
          obsidian.enable = false;
          mako.enable = false;
          kitty.enable = false;
          fuzzel.enable = false;
          hyprlock.enable = false;
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font Mono";
          };
          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
          sizes = {
            applications = 11;
            terminal = 12;
            desktop = 11;
            popups = 11;
          };
        };
      };
    };
}
