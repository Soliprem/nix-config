_: {
  programs.qutebrowser = {
    enable = true;
    settings = {
      tabs.show = "switching";
      colors.webpage.darkmode.enabled = false;
      url = {
        start_pages = "~/.config/homepage/homepage.html";
        default_page = "~/.config/homepage/homepage.html";
      };
    };
    searchEngines = {
      d = "https://www.dandwiki.com/w/index.php?title=Special%3ASearch&search={}&go=Go";
    };
  };
}
