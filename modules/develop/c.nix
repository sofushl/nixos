{
  flake.nixosModules.c =
    { userconf, pkgs, ... }:
    let
      libs = with pkgs; [
        gcc
        clang
        clang-tools
        cmake
        gnumake
      ];
    in
    {
      environment.systemPackages = libs;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
    };
}
