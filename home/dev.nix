{ pkgs, ... }: {
  programs = {
    npm = {
      enable = true;
      package = pkgs.nodejs_26;
      settings = {
        color = true;
        include = [
          "dev"
          "prod"
        ];
        init-license = "MIT";
        prefix = "\${HOME}/.npm";
      };
    };

    uv.enable = true;

  };
}
