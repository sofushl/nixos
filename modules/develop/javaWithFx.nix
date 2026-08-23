{
  flake.nixosModules.javaWithFx =
    { lib, pkgs, ... }:
    let
      jdkWithFX = pkgs.openjdk.override { enableJavaFX = true; };
    in
    {
      programs.java = {
        package = jdkWithFX;
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        scenebuilder
        maven
        jetbrains.idea
        eclipses.eclipse-java
      ];
    };
}
