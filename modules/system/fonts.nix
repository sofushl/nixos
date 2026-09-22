{
  flake.homeModules.fonts =
    { pkgs, ... }:
    let
      mono = "JetBrainsMono Nerd Font Mono";
      sans = "Inter";
      serif = "Noto Serif";
      emoji = "Noto Color Emoji";
    in
    {
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        inter
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];

      fonts.fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [
            mono
            emoji
          ];
          sansSerif = [
            sans
            emoji
          ];
          serif = [
            serif
            emoji
          ];
          emoji = [ emoji ];
        };

        antialiasing = true;
      };
    };
}
