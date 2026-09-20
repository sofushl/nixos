{
  lib,
  stdenv,
  requireFile,
  makeWrapper,
  wrapGAppsHook3,

  at-spi2-core,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  glib-networking,
  gtk3,
  libnotify,
  libxml2_13,
  nspr,
  nss,
  pango,
  systemd,
  webkitgtk_4_1,
  xz,
  zlib,
}:
let
  libDeps = [
    (lib.getLib stdenv.cc.cc)
    at-spi2-core
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    libnotify
    libxml2_13
    nspr
    nss
    pango
    systemd
    webkitgtk_4_1
    xz
    zlib
  ];
  libPath = lib.makeLibraryPath libDeps;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cisco-secure-client";
  version = "5.1.12.146";

  src = requireFile {
    name = "cisco-secure-client-linux64-${finalAttrs.version}-core-vpn-webdeploy-k9.sh";
    hash = "sha256-Ax/vWLOdmCaXKiUWF0AQinP5ggq+jcybES0142NuuhQ=";
    url = "https://software.cisco.com/download/home/286330811/type/282364313";
    message = ''
      Download the Linux "Core & AnyConnect VPN" webdeploy installer from
      Cisco (or your institution's VPN portal), then add it to the store:

        nix-store --add-fixed sha256 cisco-secure-client-linux64-${finalAttrs.version}-core-vpn-webdeploy-k9.sh
    '';
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = libDeps ++ [ glib-networking ];

  dontPatchELF = true;
  dontStrip = true;
  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack

    cp "$src" installer.sh
    chmod +w installer.sh

    begin=$(($(grep -an -m1 -- '--BEGIN ARCHIVE--' installer.sh | cut -d: -f1) + 1))
    end=$(($(grep -an -m1 -- '--END ARCHIVE--' installer.sh | cut -d: -f1) - 1))
    head -n "$end" installer.sh | tail -n +"$begin" | head -c -1 > payload.tar.gz

    mkdir -p payload
    tar -xzf payload.tar.gz -C payload --strip-components=1
    chmod -R u+w payload

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    prefix="$out/opt/cisco/secureclient"
    mkdir -p "$prefix"/{bin,lib,resources}

    install -m755 -t "$prefix/bin" \
      payload/vpnagentd \
      payload/vpn \
      payload/vpnui \
      payload/acwebhelper \
      payload/acextwebhelper \
      payload/acinstallhelper \
      payload/manifesttool_vpn \
      payload/vpndownloader \
      payload/vpndownloader-cli \
      payload/load_tun.sh

    mkdir -p "$prefix/bin/plugins"
    install -m755 -t "$prefix/bin/plugins" \
      payload/libacwebhelper.so \
      payload/libvpnipsec.so \
      payload/libacfeedback.so \
      payload/libacdownloader.so

    install -m755 -t "$prefix/lib" \
      payload/libvpnagentutilities.so \
      payload/libvpncommon.so \
      payload/libvpncommoncrypt.so \
      payload/libvpnapi.so \
      payload/libacruntime.so \
      payload/libacciscossl.so \
      payload/libacciscocrypto.so \
      payload/libaccurl.so.4.8.0 \
      payload/libboost_*.so \
      payload/cfom.so

    ln -s libaccurl.so.4.8.0 "$prefix/lib/libaccurl.so.4"

    cp -r payload/resources/. "$prefix/resources/"

    install -m644 -t "$prefix" \
      payload/ACManifestVPN.xml \
      payload/AnyConnectProfile.xsd \
      payload/AnyConnectLocalPolicy.xsd \
      payload/update.txt \
      payload/DigiCertAssuredIDRootCA.pem \
      payload/VeriSignClass3PublicPrimaryCertificationAuthority-G5.pem

    install -Dm644 payload/com.cisco.secureclient.gui.desktop \
      "$out/share/applications/com.cisco.secureclient.gui.desktop"
    substituteInPlace "$out/share/applications/com.cisco.secureclient.gui.desktop" \
      --replace-fail /opt/cisco/secureclient/bin/vpnui "$out/bin/vpnui"

    for size in 48 64 96 128 256 512; do
      install -Dm644 "payload/resources/vpnui$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/cisco-secure-client.png"
    done

    install -Dm644 payload/license.txt -t "$out/share/doc/${finalAttrs.pname}"

    runHook postInstall
  '';

  postFixup = ''
    prefix="$out/opt/cisco/secureclient"
    mkdir -p "$out/bin"
    for exe in vpn vpnui; do
      makeWrapper "$prefix/bin/$exe" "$out/bin/$exe" \
        --set-default NIX_LD "${lib.getLib stdenv.cc.libc}/lib/ld-linux-x86-64.so.2" \
        --prefix NIX_LD_LIBRARY_PATH : "${libPath}" \
        --prefix LD_LIBRARY_PATH : "${libPath}" \
        "''${gappsWrapperArgs[@]}"
    done
  '';

  passthru = {
    installPrefix = "/opt/cisco/secureclient";
    inherit libPath libDeps;
  };

  meta = {
    description = "Cisco Secure Client (formerly AnyConnect) VPN client";
    homepage = "https://www.cisco.com/site/us/en/products/security/secure-client/index.html";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vpn";
  };
})
