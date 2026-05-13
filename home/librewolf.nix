{
  programs.librewolf = {
    enable = true;

    profiles.default = {
      settings = {
        "webgl.disabled" = false;
        "privacy.resistfingerprinting" = false;
        "firefoxsync.disabled" = false;
      };

      userChrome = ../dotfiles/librewolf.css;

    };

  };

}
