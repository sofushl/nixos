rec {
  topDom = "sofus.privatedns.org";
  cloudDom = "cloud.sofus.privatedns.org";
  secondaryDom = "sofus.undo.it";
  aiDom = "ai.sofus.privatedns.org";
  searchDom = "search.sofus.privatedns.org";

  domains = [

    topDom
    cloudDom
    secondaryDom
    aiDom
    searchDom

  ];

  gitPullers = [
    "/var/www/homepage"
  ];

}
