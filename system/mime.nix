_: {
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/http" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/https" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/about" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/unknown" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
    };
  };
}
