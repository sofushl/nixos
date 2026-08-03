{ pkgs, ... }:

rec {
  topDom = "sofus.privatedns.org";
  cloudDom = "cloud.${topDom}";
  secondaryDom = "sofus.undo.it";
  aiDom = "ai.${topDom}";
  mcDom = "mc.${topDom}";
  apiDom = "api.${topDom}";
  emailApiDom = "email.${apiDom}";

  domains = [

    topDom
    cloudDom
    secondaryDom
    aiDom
    mcDom
    apiDom
    emailApiDom

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
      domain = emailApiDom;
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
