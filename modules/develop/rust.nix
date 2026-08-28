{
  flake.nixosModules.rust =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        rustc
        cargo
        clippy
        rust-analyzer
        rustlings
      ];
    };
}
