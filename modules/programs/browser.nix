{
  flake.homeModules.browser =
    {
      config,
      pkgs,
      userconf,
      ...
    }:
    {

      # REQUIRES PRESERVATION OF "$HOME/.librewolf"

      home.file.".config/mozilla/firefox".source =
        config.lib.file.mkOutOfStoreSymlink "/home/${userconf.username}/.librewolf";

      programs.librewolf = {
        enable = true;
        package = pkgs.${userconf.browser};

        settings = {
          "librewolf.webgl.promt" = false;
          "identity.fxaccounts.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.policies.runOncePerModification.setDefaultSearchEngine" = "DuckDuckGo";
          "browser.toolbars.bookmarks.visibility" = "never";
          "privacy.resistFingerprinting" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.fingerprintingProtection.pbmode" = true;
          "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
          "layout.css.prefers-color-scheme.content-override" = 0;
          "media.peerconnection.ice.default_address_only" = true;
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.open-uri" = 1;
          "widget.wayland.fractional-scale.enabled" = true;
        };

        profiles.default = {
          isDefault = true;
          userChrome = ''
            :root {
              --ui-bg: #1E1E1E;
              --ui-bg-raised: #2A2A2A;
              --ui-fg: #E0E0E3;
              --ui-border: #505050;
              --ui-accent: #DC6666;

              /* surfaces */
              --lwt-accent-color: var(--ui-bg) !important;
              --toolbar-bgcolor: var(--ui-bg) !important;
              --toolbar-color: var(--ui-fg) !important;
              --toolbar-field-background-color: var(--ui-bg) !important;
              --toolbar-field-focus-background-color: var(--ui-bg) !important;
              --toolbar-field-color: var(--ui-fg) !important;
              --toolbar-field-border-color: var(--ui-border) !important;
              --sidebar-background-color: var(--ui-bg) !important;
              --sidebar-text-color: var(--ui-fg) !important;
              --panel-background: var(--ui-bg) !important;
              --panel-color: var(--ui-fg) !important;
              --arrowpanel-background: var(--ui-bg) !important;
              --arrowpanel-color: var(--ui-fg) !important;
              --arrowpanel-border-color: var(--ui-border) !important;

              /* tabs */
              --tab-background-color: var(--ui-bg) !important;
              --tab-background-color-hover: var(--ui-bg-raised) !important;
              --tab-background-color-selected: var(--ui-bg-raised) !important;
              --uc-nav-width: max(420px, 35vw);

              /* accent */
              --color-accent-primary: var(--ui-accent) !important;
              --color-accent-primary-hover: var(--ui-accent) !important;
              --color-accent-primary-active: var(--ui-accent) !important;
              --button-primary-bgcolor: var(--ui-accent) !important;
              --button-primary-hover-bgcolor: var(--ui-accent) !important;
              --button-primary-active-bgcolor: var(--ui-accent) !important;
              --focus-outline-color: var(--ui-accent) !important;
              --toolbar-field-focus-border-color: var(--ui-accent) !important;
              --tab-loading-fill: var(--ui-accent) !important;
              --link-color: var(--ui-accent) !important;
              accent-color: var(--ui-accent) !important;

              /* no rounding */
              --border-radius-small: 0 !important;
              --border-radius-medium: 0 !important;
              --border-radius-large: 0 !important;
              --border-radius-circle: 0 !important;
              --tab-border-radius: 0 !important;
              --toolbarbutton-border-radius: 0 !important;
              --urlbar-border-radius: 0 !important;
              --arrowpanel-border-radius: 0 !important;
              --menuitem-border-radius: 0 !important;
            }

            *, *::before, *::after {
              border-radius: 0 !important;
            }

            menuitem:hover,
            treechildren::-moz-tree-row(selected) {
              background-color: var(--ui-accent) !important;
              color: var(--ui-bg) !important;
            }

            :is(#navigator-toolbox, #TabsToolbar, #nav-bar, #PersonalToolbar) {
              background-color: var(--ui-bg) !important;
              color: var(--ui-fg) !important;
              border: none !important;
            }

            /* tabs: no border, selected tab gets a 2px accent line at the bottom */
            .tab-background {
              border: none !important;
              outline: none !important;
              box-shadow: none !important;
            }

            .tab-background[selected] {
              border-bottom: 2px solid var(--ui-accent) !important;
            }

            /* single row: nav bar left, tabs right */
            #navigator-toolbox {
              display: grid !important;
              grid-template-columns: var(--uc-nav-width) minmax(0, 1fr) !important;
              grid-auto-rows: auto !important;
            }

            #titlebar {
              display: contents !important;
            }

            #navigator-toolbox > #nav-bar {
              grid-column: 1 !important;
              grid-row: 1 !important;
            }

            #TabsToolbar {
              grid-column: 2 !important;
              grid-row: 1 !important;
              min-width: 0 !important;
              overflow: hidden !important;
            }

            #TabsToolbar #tabbrowser-tabs {
              min-width: 0 !important;
            }

            /* everything else goes on its own row below */
            #toolbar-menubar,
            #PersonalToolbar,
            #navigator-toolbox > :not(#titlebar, #nav-bar, #TabsToolbar) {
              grid-column: 1 / -1 !important;
              grid-row: auto !important;
            }
          '';

          search = {
            default = "ddg";
            force = true;
            order = [
              "ddg"
              "wikipedia"
              "np"
              "no"
              "nw"
            ];

            engines = {
              nix-options = {
                name = "Nix Options";
                urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              nix-packages = {
                name = "Nix Packages";
                urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                definedAliases = [ "@nw" ];
              };

              google.metaData.alias = "@g";
              wikipedia.metaData.alias = "@w";

              bing.metaData.hidden = true;
              perplexity.metaData.hidden = true;
            };
          };
        };
      };
    };
}
