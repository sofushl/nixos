{ self, inputs, ... }:

{
  flake.nixosModules.librewolf =
    { userconf, ... }:

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

            handlers = {
              #mimeTypes = { };
              schemes = {
                mailto = {
                  action = 2;
                  ask = false;
                  handlers = [
                    {
                      name = "Gmail";
                      uriTemplate = "https://mail.google.com/mail/?extsrc=mailto&url=%s";
                    }
                  ];
                };
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
