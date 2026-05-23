{ self, inputs, ... }:

{
  flake.nixosModules.MODULENAME =
    { userconf, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fastfetch ];
      environment.etc.fastfetch.source = "../../dotfiles/fastfetch";
    };
}
