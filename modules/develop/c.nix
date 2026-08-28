{
  flake.nixosModules.c =
    { userconf, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gcc
        clang
        clang-tools
        cmake
      ];
    };
}
