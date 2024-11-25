{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        ",h" = "hint links spawn mpv {hint-url}";
        ",m" = "spawn mpv {url}";
        ",t" = "config-cycle tabs.show always switching";
        ",s" = "config-cycle statusbar.show always in-mode";
      };
    };
    settings = {
      tabs = {
        show = "switching";
        position = "left";
      };
      downloads.remove_finisched = 10000;
      colors.webpage.darkmode.enabled = false;
      url = {
        start_pages = "~/.config/homepage/homepage.html";
        default_page = "~/.config/homepage/homepage.html";
      };
    };
    searchEngines = {
      da = "https://www.dandwiki.com/w/index.php?title=Special%3ASearch&search={}&go=Go";
      ds = "http://www.d20srd.org/search.htm?q={}";
      h = "https://home-manager-options.extranix.com/?query={}";
      np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
    };
  };
}
