{ self, ... }: {
  flake.homeModules.headless = {
    imports = with self.homeModules; [
      base
      environment
      user

      neovim
      yazi
      claude
      git
      bash
      fastfetch
    ];
  };
}
