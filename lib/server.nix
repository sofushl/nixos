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

  domains = [
    topDom
    secondaryDom
    apiDom

    cloudDom
    aiDom
    mcDom
    rgbDom

    emailApi
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
      locations = {
        "/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
        "/email" = {
          proxyPass = "https://email.api.sofus.privatedns.org/email";
          recommendedProxySettings = false;
          extraConfig = ''
            proxy_ssl_server_name on;
            proxy_set_header Host email.api.sofus.privatedns.org;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
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
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    }
  ];

  minecraft = {
    jvmOpts12 = "-Xms12G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";

    jvmOpts8 = "-Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";

    prioServiceConfig = {
      CPUWeight = 500;
      IOWeight = 500;
      OOMScoreAdjust = 100;
    };
  };
}
