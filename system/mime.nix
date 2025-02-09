_: {
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/http" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/https" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/about" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/unknown" = ["zen.desktop" "org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/nxm" = "vortex-downloads-handler.desktop";
      "x-scheme-handler/nxm-protocol" = "vortex-downloads-handler.desktop";
      "video/mp2t" = "mpv.desktop";
      "video/vnd.avi" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/vnd.mpegurl" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/dv" = "mpv.desktop";
      "video/x-flic" = "mpv.desktop";
      "video/vnd.rn-realvideo" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/3gpp2" = "mpv.desktop";
    };
  };
}
