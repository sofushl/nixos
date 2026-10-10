{ self, inputs, ... }:
{
  flake.nixosModules.mimeapps =
    { userconf, ... }:
    {
      home-manager.users.${userconf.username}.imports = [ self.homeModules.mimeapps ];
    };

  flake.homeModules.mimeapps =
    { lib, ... }:
    let
      apps = {
        browser = "firefox.desktop";
        fileManager = "yazi.desktop";
        editor = "nvim.desktop";
        image = "loupe.desktop";
        video = "vlc.desktop";
        audio = "vlc.desktop";
        spotify = "spotify.desktop";
        discord = "discord.desktop";
        steam = "steam.desktop";
        torrent = "org.qbittorrent.qBittorrent.desktop";
      };

      assign = app: types: lib.genAttrs types (_: app);
    in
    {
      xdg.mimeApps = {
        enable = true;

        defaultApplications = lib.mergeAttrsList [
          (assign apps.browser [
            "text/html"
            "application/xhtml+xml"
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-xhtml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/about"
            "x-scheme-handler/unknown"
            "x-scheme-handler/chrome"
            "x-scheme-handler/mailto"
            "message/rfc822"
            "application/pdf"
            "application/epub+zip"
            "image/vnd.djvu"
          ])

          (assign apps.fileManager [
            "inode/directory"
            "application/zip"
            "application/x-tar"
            "application/gzip"
            "application/x-xz"
            "application/zstd"
            "application/x-bzip2"
            "application/x-7z-compressed"
            "application/vnd.rar"
            "application/x-compressed-tar"
            "application/x-xz-compressed-tar"
          ])

          (assign apps.editor [
            "text/plain"
            "text/markdown"
            "text/x-csrc"
            "text/x-chdr"
            "text/x-c++src"
            "text/x-python"
            "text/x-shellscript"
            "text/x-nix"
            "text/css"
            "text/csv"
            "text/xml"
            "application/json"
            "application/x-yaml"
            "application/toml"
            "application/x-shellscript"
          ])

          (assign apps.image [
            "image/png"
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/bmp"
            "image/tiff"
            "image/svg+xml"
            "image/avif"
            "image/heif"
          ])

          (assign apps.video [
            "video/mp4"
            "video/x-matroska"
            "video/webm"
            "video/mpeg"
            "video/quicktime"
            "video/x-msvideo"
            "video/ogg"
          ])

          (assign apps.audio [
            "audio/mpeg"
            "audio/flac"
            "audio/ogg"
            "audio/opus"
            "audio/x-wav"
            "audio/mp4"
            "audio/aac"
            "audio/x-vorbis+ogg"
          ])

          (assign apps.spotify [
            "x-scheme-handler/spotify"
          ])

          (assign apps.discord [ "x-scheme-handler/discord" ])
          (assign apps.steam [
            "x-scheme-handler/steam"
            "x-scheme-handler/steamlink"
          ])
          (assign apps.torrent [
            "application/x-bittorrent"
            "x-scheme-handler/magnet"
          ])
        ];

        associations.added = {
          "application/pdf" = [ apps.browser ];
          "text/html" = [ apps.editor ];
        };
      };
      xdg.enable = true;
    };
}
