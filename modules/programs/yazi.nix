{
  flake.homeModules.yazi = { pkgs, ... }: {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = true;

        theme.mgr.syntect_theme =
          let
            src = pkgs.fetchFromGitHub {
              owner = "956MB";
              repo = "vscode-dark-plus.yazi";
              rev = "e9f118a8572b8ee96624bc778b80337d8b9f8b96";
              hash = "sha256-aYw4HuF8GaOhJEQDkgsdJn/uCdEme6kFrBkL80SFikA=";
            };
          in
          "${src}/tmtheme.xml";

        settings.mgr = {
          show_hidden = false;
          sort_dir_first = true;
          sort_reverse = false;
        };

        plugins = {
          bypass = pkgs.fetchFromGitHub {
            owner = "Rolv-Apneseth";
            repo = "bypass.yazi";
            rev = "main";
            hash = "sha256-kho114UcjV90BDghZxUn2gZXtjY0tsE+C9ttlQZli6U=";
          };
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
  };
}
