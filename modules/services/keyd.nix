{
  flake.nixosModules.keyd.services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          compose = "layer(nav)";
          copilot = "layer(nav)";
          rightcontrol = "layer(meta)";
          leftalt = "layer(meta)";
          capslock = "esc";
        };
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          rightalt = "compose";
          leftalt = "leftalt";
          rightcontrol = "rightcontrol";
          capslock = "capslock";
        };
      };
    };
  };

}
