{ self, inputs, ... }:

{
  flake.nixosModules.vscodium =

    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          vscodevim.vim

          redhat.java
          vscjava.vscode-maven
          vscjava.vscode-java-dependency
          vscjava.vscode-java-debug

          ms-python.python
          ms-python.debugpy
          #ms-python.vscode-python-envs

          myriad-dreamin.tinymist

          #v1hz.kdl
        ];
      };
      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".config/VSCodium"
      ];

    };
}
