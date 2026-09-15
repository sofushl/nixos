{
  flake.nixosModules.mplab =
    { pkgs, userconf, ... }:

    # REQUIRES PRESERVATION OF "opt" "$HOME.config/Code" "$HOME.vscode" "$HOME.vscode-shared" "$HOME.mplab" "$HOME.mplabcomm" "$HOME.mchp_packs"

    let

      xc8src = pkgs.fetchurl {
        url = "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v4.00-full-install-linux-x64-installer.run";
        hash = "sha256-c11lurCPpDktqdubWmJNGzJ0Nq71fSNxkmWJIeiM/QY=";
      };

      libs = with pkgs; [
        libx11
        libxext
        libxi
        libxrender
        libxtst
      ];
    in
    {
      environment.systemPackages =
        with pkgs;
        [
          (pkgs.writeShellScriptBin "xc8-install" ''
            ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ${xc8src}
          '')
          cmake
          vscode
        ]
        ++ libs;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;

      services.udev.packages = [
        (pkgs.runCommandLocal "mplab-udev-rules" { } ''
          mkdir -p $out/lib/udev/rules.d
          cp ${pkgs.writeText "z010_mchp_tools.rules" ''
            # 2018.09.11 Remove calls to mchplinusbdevice.
            # 2017.09.25 Added check for Microchip product IDs.
            # 2017.03,03 Added check for Atmel tools.
            # 2012.01.23 Changed SYSFS reference(s) to ATTR.
            # 2011.12.15 Note: Reboot works on all systems to have rules file recognized.
            # 2010.01.26 Add reference to "usb" for Ubuntu.
            # 2010.01.22 Attempt to further simplify rules files requirements.
            # 2009.08.18 Rules file simplified.
            # 2009.07.15 Rules file created.

            ACTION!="add", GOTO="rules_end"
            SUBSYSTEM=="usb_device", GOTO="check_add"
            SUBSYSTEM!="usb", GOTO="rules_end"

            LABEL="check_add"

            ATTR{idVendor}=="04d8", ATTR{idProduct}=="8???", MODE="666"
            ATTR{idVendor}=="04d8", ATTR{idProduct}=="9???", MODE="666"
            ATTR{idVendor}=="04d8", ATTR{idProduct}=="a0??", MODE="666"
            ATTR{idVendor}=="04d8", ATTR{idProduct}=="00e0", MODE="666"
            ATTR{idVendor}=="04d8", ATTR{idProduct}=="00e1", MODE="666"
            ATTR{idVendor}=="04d8", ATTR{idProduct}=="00dd", MODE="666"
            ATTR{idVendor}=="03eb", ATTR{idProduct}!="6124", MODE="666"

            LABEL="rules_end"
          ''} $out/lib/udev/rules.d/z010_mchp_tools.rules
          cp ${pkgs.writeText "z012_mchp_efr.rules" ''
            # 2017.12.15 Rules file created.

            ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="666"
            # ACTION=="add", SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="0666"

          ''} $out/lib/udev/rules.d/z012_mchp_efr.rules
        '')
      ];
    };
}
