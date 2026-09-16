{ inputs, ... }:
{
  flake.homeModules.vscodium =

    {
      userconf,
      pkgs,
      lib,
      ...
    }:

    # RECCOMENDED PERSISTANCE OF "$HOME/.config/VSCodium" "$HOME/.vscode-oss-shared"

    let
      settings = {
        "editor.formatOnSave" = true;
        "files.autoSave" = "onFocusChange";
        "workbench.colorTheme" = "Dark Modern";
        "workbench.activityBar.location" = "top";
        "claudeCode.preferredLocation" = "panel";
      };

      extensions = with pkgs.vscode-marketplace; [
        vscodevim.vim
        anthropic.claude-code
      ];
    in
    {

      nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

      programs.vscodium = {
        enable = true;
        package = pkgs.vscodium;
        argvSettings = { };
        mutableExtensionsDir = false;

        profiles = {
          default = {
            enableExtensionUpdateCheck = false;
            enableUpdateCheck = false;
            extensions = extensions;
            userSettings = settings;
          };
          java = {
            userSettings = settings;
            extensions =
              with pkgs.vscode-marketplace;
              [
                redhat.java
                vscjava.vscode-maven
                vscjava.vscode-java-dependency
                vscjava.vscode-java-debug
                vscjava.vscode-java-test
                shengchen.vscode-checkstyle
              ]
              ++ extensions;
          };
          mplab = {
            userSettings = settings;
            extensions =
              with pkgs.vscode-marketplace;
              [
                eclipse-cdt.memory-inspector
                microchip.mplab-clangd
                microchip.mplab-code-configurator
                microchip.mplab-core-da
                microchip.mplab-data-visualizer
                microchip.mplab-extensions-core
                microchip.mplab-extensions-platforms
                microchip.mplab-kconfig
                microchip.mplab-ui
                microchip.mplabx-importer
                microchip.runcmake
                microchip.toolchains
              ]
              ++ extensions;
          };
          python = {
            userSettings = settings;
            extensions =
              with pkgs.vscode-marketplace;
              [
                ms-python.python
                ms-python.debugpy
                ms-python.vscode-python-envs
                ms-python.vscode-pylance
                paulober.pico-w-go

              ]
              ++ extensions;
          };
          typst = {
            userSettings = settings;
            extensions =
              with pkgs.vscode-marketplace;
              [
                myriad-dreamin.tinymist
                tomoki1207.pdf
              ]
              ++ extensions;
          };
        };
      };
    };
}
