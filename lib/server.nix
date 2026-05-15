rec {
  topDom = "sofus.undo.it";
  cloudDom = "cloud.sofus.undo.it";

  domains = [
    topDom
    cloudDom
  ];

  freednsUpdate = "${userconf.freednsupdate}";
}
