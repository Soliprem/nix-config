{
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      search.placeholder = "Search:";
      ui.fullscreen = true;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };
  };
}
