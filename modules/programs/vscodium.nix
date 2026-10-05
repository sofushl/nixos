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
        "claudeCode.hideOnboarding" = true;
        "claudeCode.preferredLocation" = "panel";
        "editor.formatOnSave" = true;
        "explorer.confirmDragAndDrop" = false;
        "files.autoSave" = "onFocusChange";
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.openRepositoryInParentFolders" = "always";
        "workbench.activityBar.location" = "top";
        "workbench.colorTheme" = "Dark Modern";
      };

      extensions = with pkgs.vscode-marketplace; [
        vscodevim.vim
        anthropic.claude-code
        vivaxy.vscode-conventional-commits
      ];

      # Explaination in readme
      mplab-ui-patched = pkgs.vscode-marketplace.microchip.mplab-ui.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace "$out/$installPrefix/dist/extension.js" \
            --replace-fail 'c.join(__dirname,"data")' \
              '(process.env.HOME + "/.mplab/mplab-ui-data")'
        '';
      });

      dependencies = with pkgs; [
        graphviz
        typst
      ];
    in
    {

      nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

      programs.vscodium = {
        enable = true;
        package = pkgs.vscodium-fhs;
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
            userSettings = settings // {
              "editor.defaultFormatter" = "redhat.java";
              "redhat.telemetry.enabled" = false;
            };
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
                raspberry-pi.raspberry-pi-pico
                marus25.cortex-debug
                mcu-debug.debug-tracker-vscode
                mcu-debug.memory-view
                mcu-debug.rtos-views
                mcu-debug.peripheral-viewer
                # 4.4.0+ requires VS Code ^1.137
                (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
                  mktplcRef = {
                    publisher = "paulober";
                    name = "pico-w-go";
                    version = "4.3.4";
                    arch = "linux-x64";
                    hash = "sha256-BJW/rXLU3LvAT6FVwE2yoDfC4H5d559g82Qw5mK1rMQ=";
                  };
                })
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
          docker = {
            userSettings = settings;
            extensions =
              with pkgs.vscode-marketplace;
              [
                ms-azuretools.vscode-docker
                ms-azuretools.vscode-containers
              ]
              ++ extensions;
          };
        };
      };

      home.packages = with pkgs; [ ] ++ dependencies;
    };
}
