{ self, inputs, ... }:

{

  # Makes right alt into a secondary super/mod/windows button
  flake.nixosModules.keyd.services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          compose = "layer(nav)";
          rightcontrol = "layer(meta)";
          capslock = "esc";
        };
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          rightalt = "compose";
          rightcontrol = "rightcontrol";
          capslock = "capslock";
        };
      };
    };
  };

}
