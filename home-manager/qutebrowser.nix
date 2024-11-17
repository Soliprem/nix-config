_: {
  programs.qutebrowser = {
    enable = true;
    settings = {
      tabs.show = "switching";
      colors.webpage.darkmode.enabled = false;
    };
    searchEngines = {
      d = "https://www.dandwiki.com/w/index.php?title=Special%3ASearch&search={}&go=Go";
    };
  };
}
