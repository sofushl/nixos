{ pkgs, ... }:

rec {
  topDom = "sofus.privatedns.org";
  secondaryDom = "sofus.undo.it";
  apiDom = "api.${topDom}";

  cloudDom = "cloud.${topDom}";
  aiDom = "ai.${topDom}";
  mcDom = "mc.${topDom}";
  rgbDom = "rgb.${topDom}";

  emailApi = "email.${apiDom}";
  rgbApi = "rgb.${apiDom}";

  domains = [
    topDom
    secondaryDom
    apiDom

    cloudDom
    aiDom
    mcDom
    rgbDom

    emailApi
    rgbApi
  ];

  wifiboard = "eth";

  gitServices = [
    {
      name = "portfolio";
      subdir = "/dist";
      repo = "https://github.com/sofushl/portfolio.git";
      domain = topDom;
      build = ''
        npm i
        npm run build
      '';
    }
    {
      name = "AbaCordium";
      repo = "https://github.com/AbaCord/AbaCordium.git";
      build = ''
        npm i
      '';
      start = ''
        npm start
      '';
    }
    {
      name = "email-backend";
      repo = "https://github.com/sofushl/email-backend.git";
      start = "./target/release/email-backend";
      build = "cargo build --release --locked";
      port = 3000;
      domain = emailApi;
      env = {
        CARGO_HOME = "/var/www/email-backend/.cargo";
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      };
      pack = with pkgs; [
        cargo
        rustc
        stdenv.cc
        pkg-config
        openssl
      ];
    }
  ];
}
