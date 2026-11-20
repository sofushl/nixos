pkgs: {
  # yazi
  yaziVscodeDarkPlus = pkgs.fetchFromGitHub {
    owner = "956MB";
    repo = "vscode-dark-plus.yazi";
    rev = "e9f118a8572b8ee96624bc778b80337d8b9f8b96";
    hash = "sha256-aYw4HuF8GaOhJEQDkgsdJn/uCdEme6kFrBkL80SFikA=";
  };

  yaziBypass = pkgs.fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "4a0c70ec9122d884deb659ff620af0098314c136";
    hash = "sha256-kho114UcjV90BDghZxUn2gZXtjY0tsE+C9ttlQZli6U=";
  };

  # minecraft
  achievementcomp = pkgs.fetchFromGitHub {
    owner = "sofushl";
    repo = "achievementcomp";
    rev = "c5c47b16994162bde5f02751562811464247648b";
    hash = "sha256-OTC/y6v0SbDwCDrP8bNQdzPDcZUXNS93Uu1ULZKAnrg=";
  };

  bluemapPlugin = pkgs.fetchurl {
    url = "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v5.29/bluemap-5.29-paper.jar";
    hash = "sha256-e/R1k2wmEH1HbGMVHHbVtJ6GXuvq2hLJ59khVd6He58=";
  };

  # neovim
  mcfunction-grammar = pkgs.tree-sitter.buildGrammar {
    language = "mcfunction";
    version = "0.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "bbfh-dev";
      repo = "tree-sitter-mcfunction";
      rev = "d96ad2794d2f3b21f146e3203546ab5776874dac";
      hash = "sha256-JznyZqkk3esSkF93IW5pb/dqLmu3UFwIn1uQWdVCsN4=";
    };
  };

  mcfunction-lsp = pkgs.buildGoModule {
    pname = "mcfunction-lsp";
    version = "unstable-2024-03-20";
    src = pkgs.fetchFromGitHub {
      owner = "mend-lang";
      repo = "mcfunction-lsp";
      rev = "3bc37bc271dce1a3a3a331149cdb17447054ddb6";
      hash = "sha256-xb0BU3MkklR4yzstOTfhy9mIsLv84u6Mpi9u2EjLvTQ=";
    };
    vendorHash = "sha256-qkBpSVLWZPRgS9bqOVUWHpyj8z/nheQJON3vJOwPUj4=";
    subPackages = [ "." ];
  };

  # mplab
  xc8src = pkgs.fetchurl {
    url = "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v4.00-full-install-linux-x64-installer.run";
    hash = "sha256-c11lurCPpDktqdubWmJNGzJ0Nq71fSNxkmWJIeiM/QY=";
  };

  # wifi
  ntnuRootCa = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/sofushl/a45bf61f53b133a2d2f9d6b206995379/raw/059595c7847674b9ef2f810416b2548ab4189725/ntnu-root-ca.pem";
    hash = "sha256-0uuK05B0jCO+uAQ+yN89tcdGyIAgJBURPYQ9ji+jenM=";
  };

  # claude
  ponytail = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "96608e078b2d5ea607c5c3b8b5a54d1c1fba6846";
    hash = "sha256-PhPtZbeX2wBp19GtWRy+fV93+fFYZe5S487eXPDl/us=";
  };

  agentSkills = pkgs.fetchFromGitHub {
    owner = "addyosmani";
    repo = "agent-skills";
    rev = "8c99fa36d90068c82d547f7c12a9d67a3e95f4ee";
    hash = "sha256-LqVRMZ5sSxXkCt5/PwYeJeiJxpQtAdUuQYIDrcQH1+A=";
  };
}
