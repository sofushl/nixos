{ self, inputs, ... }:

{
  flake.nixosModules.fastfetch =
    { userconf, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fastfetch ];
      environment.etc.fastfetch.source = ../../dotfiles/fastfetch;
    };
}
