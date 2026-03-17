{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.alacritty ];
  environment.etc = {
    "alacritty/alacritty.toml" = {
      text = ''
        #toml

        [colors.primary]
        background = '#1E1E1E'
        foreground = '#E0E0E0'

        [colors.selection]
        text = '#1E1E1E'
        background = '#DC6666'

        [colors.cursor]
        text = '#1E1E1E'
        cursor = '#DC6666'

        [colors.normal]
        black   = '#1E1E1E'
        red     = '#DC6666'
        green   = '#DC6666'
        yellow  = '#DC6666'
        blue    = '#DC6666'
        magenta = '#DC6666'
        cyan    = '#DC6666'
        white   = '#E0E0E0'

        [colors.bright]
        black   = '#1E1E1E'
        red     = '#DC6666'
        green   = '#DC6666'
        yellow  = '#DC6666'
        blue    = '#DC6666'
        magenta = '#DC6666'
        cyan    = '#DC6666'
        white   = '#E0E0E0'

        [window]
        decorations = "None"
        padding = { x = 3, y = 3 }
        opacity = 1.0

        [scrolling]
        history = 3023

        [cursor]
        style = { shape = "Block", blinking = "On" }
        unfocused_hollow = true

        [mouse]
        hide_when_typing = true

      '';
    };
  };
}
