{ self, ... }: {
  flake.homeModules.headless = {
    imports = with self.homeModules; [
      base
      environment
      user

      docker
      neovim
      yazi
      claude
      git
      bash
      fastfetch
    ];
  };
}
