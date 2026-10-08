{ nixpkgs, stablepkgs, ... }:

rec {
  topDom = "sofus.privatedns.org";
  apiDom = "api.${topDom}";

  cloudDom = "cloud.${topDom}";
  aiDom = "ai.${topDom}";
  mcDom = "mc.${topDom}";
  rgbDom = "rgb.${topDom}";

  emailApi = "email.${apiDom}";

  domains = [
    topDom
    apiDom

    cloudDom
    aiDom
    mcDom
    rgbDom

    emailApi
  ];

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
      name = "LightsUI";
      repo = "https://github.com/sofushl/LightsUI.git";
      start = "IP=http://192.168.1.100/ ./target/release/LightsUI";
      build = ''
        cargo build --release --locked && \
        topcoat asset bundle --release
      '';
      port = 4210;
      domain = rgbDom;
      env = {
        CARGO_HOME = "/var/www/LightsUI/.cargo";
        PKG_CONFIG_PATH = "${stablepkgs.openssl.dev}/lib/pkgconfig";
      };
      pack = with nixpkgs; [
        cargo
        rustc
        stdenv.cc
        pkg-config
        openssl
        topcoat-cli
      ];
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:4210";
          extraConfig = ''
            allow 127.0.0.1;
            allow ::1;
            allow 192.168.0.0/16;
            allow 10.0.0.0/8;
            allow fe80::/10;
            allow fc00::/7; 
            deny all;
          '';
        };
      };
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
        PKG_CONFIG_PATH = "${stablepkgs.openssl.dev}/lib/pkgconfig";
      };
      pack = with stablepkgs; [
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
