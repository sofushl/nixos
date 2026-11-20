# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.yazi =
    { pkgs, ... }:
    let
      inherit (import ../../lib/pkgs.nix pkgs) yaziVscodeDarkPlus yaziBypass;

      dependencies = with pkgs; [
        ffmpeg
        jq
        poppler
        fd
        ripgrep
        fzf
        zoxide
        resvg
        imagemagick
        wl-clipboard
      ];
    in
    {
      programs = {
        yazi = {
          enable = true;
          enableBashIntegration = true;

          theme.mgr.syntect_theme = "${yaziVscodeDarkPlus}/tmtheme.xml";

          settings.mgr = {
            show_hidden = false;
            sort_dir_first = true;
            sort_reverse = false;
            show_symlink = false;
          };

          plugins = {
            bypass = yaziBypass;
          };

          keymap = {
            mgr.prepend_keymap = [
              {
                on = [ "l" ];
                run = "plugin bypass smart-enter";
                desc = "Open file / enter directory, skipping single-child dirs";
              }
              {
                on = [ "<Right>" ];
                run = "plugin bypass smart-enter";
                desc = "Open file / enter directory, skipping single-child dirs";
              }
              {
                on = [ "h" ];
                run = "plugin bypass reverse";
                desc = "Leave directory, skipping single-child dirs";
              }
              {
                on = [ "<Left>" ];
                run = "plugin bypass reverse";
                desc = "Leave directory, skipping single-child dirs";
              }
              {
                on = [ "L" ];
                run = "enter";
                desc = "Enter one directory level, no skipping";
              }
              {
                on = [ "H" ];
                run = "leave";
                desc = "Leave one directory level, no skipping";
              }
            ];
          };
        };
      };

      home.packages = dependencies;
    };
}
