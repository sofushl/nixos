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
        "redhat.telemetry.enabled" = false;
        "git.confirmSync" = false;
        "git.openRepositoryInParentFolders" = "always";
        "git.enableSmartCommit" = true;
      };

      extensions = with pkgs.vscode-marketplace; [
        vscodevim.vim
        anthropic.claude-code
        vivaxy.vscode-conventional-commits
        eamodio.gitlens
      ];

      # Explaination in readme
      mplab-ui-patched = pkgs.vscode-marketplace.microchip.mplab-ui.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace "$out/$installPrefix/dist/extension.js" \
            --replace-fail 'c.join(__dirname,"data")' \
              '(process.env.HOME + "/.mplab/mplab-ui-data")'
        '';
      });
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
          node = {
            userSettings = settings;
            extensions =
              with pkgs.vscode-marketplace;
              [
                connor4312.esbuild-problem-matchers
                dbaeumer.vscode-eslint
                orta.vscode-jest
                firsttris.vscode-jest-runner
                esbenp.prettier-vscode
                bradlc.vscode-tailwindcss
                hbenl.vscode-test-explorer
                ms-vscode.test-adapter-converter
                ms-vscode.vscode-js-profile-flame
              ]
              ++ extensions;
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
                jebbs.plantuml
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
                microchip.mplabx-importer
                microchip.runcmake
                microchip.toolchains
                mplab-ui-patched
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
