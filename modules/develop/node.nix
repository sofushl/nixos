{
  flake.nixosModules.node = { pkgs, ... }: {
    programs.npm = {
      enable = true;
      package = pkgs.nodejs_26;
      npmrc = ''
        prefix = ''${HOME}/.npm
        init-license=MIT
        color=true
      '';
    };
  };
}
