_: {
  files = {
    ".config/wlogout/layout".text = ''
      {
          "label" : "lock",
          "action" : "swaylock",
          "text" : "lock",
          "keybind" : "l"
      }
      {
          "label" : "hibernate",
          "action" : "systemctl hibernate",
          "text" : "save",
          "keybind" : "h"
      }
      {
          "label" : "logout",
          "action" : "killall Hyprland",
          "text" : "logout",
          "keybind" : "e"
      }
      {
          "label" : "shutdown",
          "action" : "systemctl poweroff",
          "text" : "shutdown",
          "keybind" : "s"
      }
      {
          "label" : "suspend",
          "action" : "systemctl suspend",
          "text" : "bedtime",
          "keybind" : "u"
      }
      {
          "label" : "reboot",
          "action" : "systemctl reboot",
          "text" : "reboot",
          "keybind" : "r"
      }

    '';
    ".config/wlogout/style.css".text = ''
      @import './colors.css';

      window {
          font-family: Fira Code Medium;
          font-size: 16pt;
          color: @foreground;
          background-color: rgba(24, 27, 32, 0.2);
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          background-color: transparent;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s ease-in;
          box-shadow: 0 0 10px 2px transparent;
          border-radius: 36px;
          margin: 10px;
      }

      button:focus {
          box-shadow: none;
          background-size: 20%;
      }

      button:hover {
          background-size: 50%;
          box-shadow: 0 0 10px 3px rgba(0, 0, 0, .4);
          background-color: @primary;
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
      }

      #shutdown {
          background-image: image(url("${../assets/wlogout/power.png}"));
      }

      #shutdown:hover {
          background-image: image(url("${../assets/wlogout/power-hover.png}"));
      }

      #logout {
          background-image: image(url("${../assets/wlogout/logout.png}"));
      }

      #logout:hover {
          background-image: image(url("${../assets/wlogout/logout-hover.png}"));
      }

      #reboot {
          background-image: image(url("${../assets/wlogout/restart.png}"));
      }

      #reboot:hover {
          background-image: image(url("${../assets/wlogout/restart-hover.png}"));
      }

      #lock {
          background-image: image(url("${../assets/wlogout/lock.png}"));
      }

      #lock:hover {
          background-image: image(url("${../assets/wlogout/lock-hover.png}"));
      }

      #hibernate {
          background-image: image(url("${../assets/wlogout/hibernate.png}"));
      }

      #hibernate:hover {
          background-image: image(url("${../assets/wlogout/hibernate-hover.png}"));
      }

      #sleep {
          background-image: image(url("${../assets/wlogout/sleep.png}"));
      }

      #sleep:hover {
          background-image: image(url("${../assets/wlogout/sleep-hover.png}"));
      }
    '';
  };
}
