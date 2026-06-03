{ self, inputs, ... }:

{
  flake.nixosModules.librewolf =
    { userconf, pkgs, ... }:

    {
      home-manager.users.${userconf.username} = {
        programs.librewolf = {
          enable = true;

          settings = {
            "librewolf.webgl.promt" = false;
            "privacy.resistFingerprinting" = false;
            "identity.fxaccount.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.policies.runOncePerModification.setDefaultSearchEngine" = "DuckDuckGo";
            "browser.toolbars.bookmarks.visibility" = "never";
          };

          profiles.default = {

            isDefault = true;

            userChrome = ../../dotfiles/librewolf.css;

            #handlers = {
            #  mimeTypes = { };
            #  schemes = {
            #    mailto = {
            #      action = 2;
            #      ask = false;
            #      handlers = [
            #        {
            #          name = "Gmail";
            #          uriTemplate = "https://mail.google.com/mail/?extsrc=mailto&url=%s";
            #        }
            #      ];
            #    };
            #  };
            #};

            search = {

              default = "ddg";

              force = true;

              order = [
                "ddg"
                "wikipedia"
                "no"
                "nw"
                "np"
              ];

              engines = {
                nix-options = {
                  name = "Nix Options";
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "options";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "channel";
                          value = "unstable";
                        }
                      ];
                    }
                  ];

                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@no" ];
                };

                nix-packages = {
                  name = "Nix Packages";
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "channel";
                          value = "unstable";
                        }
                      ];
                    }
                  ];

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

        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "application/pdf" = "librewolf.desktop";
          };
        };
      };

    };
}
