{
  flake.homeModules.obsidian = {
    programs.obsidian = {
      enable = true;
      cli.enable = true;
      vaults.NTNU = {
        target = "Cloud/NTNU";
      };
    };
  };
}
