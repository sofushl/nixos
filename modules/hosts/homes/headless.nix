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
      opencode
      git
      bash
      fastfetch
    ];
  };
}
