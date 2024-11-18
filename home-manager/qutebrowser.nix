_: {
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        ",h" = "hint links spawn mpv {hint-url}";
        ",m" = "spawn mpv {url}";
      };
    };
    settings = {
      tabs.show = "switching";
      colors.webpage.darkmode.enabled = false;
      url = {
        start_pages = "~/.config/homepage/homepage.html";
        default_page = "~/.config/homepage/homepage.html";
      };
    };
    searchEngines = {
      da = "https://www.dandwiki.com/w/index.php?title=Special%3ASearch&search={}&go=Go";
      ds = "http://www.d20srd.org/search.htm?q={}";
    };
  };
}
