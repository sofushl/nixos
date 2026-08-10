{ inputs, ... }: {
  flake.homeModules.stylix =
    { pkgs, config, ... }:
    {

      imports = [ inputs.stylix.homeModules.stylix ];
      dconf.enable = true;

      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = {
          base00 = "1e1e1e"; # bg
          base01 = "252526"; # panel/lighter bg
          base02 = "264f78"; # selection
          base03 = "6a9955"; # comments
          base04 = "808080";
          base05 = "d4d4d4"; # default fg
          base06 = "e7e7e7";
          base07 = "ffffff";
          base08 = "f44747"; # red / errors
          base09 = "b5cea8"; # numbers
          base0A = "dcdcaa"; # functions / yellow
          base0B = "ce9178"; # strings
          base0C = "4ec9b0"; # types / cyan
          base0D = "569cd6"; # keywords / blue
          base0E = "c586c0"; # control keywords / magenta
          base0F = "d16d9e";
        };

        targets = {
          neovim.enable = false;
          firefox.profileNames = [ "default" ];
          gtk.extraCss = ''
            @define-color accent_color #DC6666;
            @define-color accent_bg_color #DC6666;
            @define-color accent_fg_color #ffffff;
          '';

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
