{...}: {
  networking = {
    useDHCP = false;
    useNetworkd = true;
    dhcpcd.enable = false;
    nameservers = [
      "2a01:4ff:ff00::add:2"
      "2a01:4ff:ff00::add:1"
      "185.12.64.1"
    ];
  };

  systemd.network = {
    enable = true;
    networks."10-hetzner" = {
      matchConfig.MACAddress = "96:00:03:6b:af:6b";
      address = [
        "49.12.104.79/32"
        "2a01:4f8:c013:4368::1/64"
      ];
      networkConfig = {
        DHCP = "no";
        DNS = [
          "2a01:4ff:ff00::add:2"
          "2a01:4ff:ff00::add:1"
          "185.12.64.1"
        ];
        IPv6AcceptRA = false;
      };
      routes = [
        {
          Destination = "172.31.1.1/32";
          Scope = "link";
        }
        {
          Destination = "0.0.0.0/0";
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        }
        {
          Destination = "::/0";
          Gateway = "fe80::1";
          GatewayOnLink = true;
        }
      ];
      linkConfig = {
        MTUBytes = "1500";
        RequiredForOnline = "routable";
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpjbbvj6BzOyDU5BLKWQr+uhJxVOCowo1v2Ok3b9KZl+FyC5Cau1yoKZe5vHBl5bAVx+89Xz0ARyTP6V0oNhkv6aFQHsu44a4OZHgyGULWVi0yH1nCxZBpuPdLN/h0xbe6MoSlN5x1rphxn33FaefeoJ1Bmc1fy+lyARZ64CETVUuSMWp0QpaPURtaNQy23kS0Si3ebY18nlyVgwfvFAw2W2fB9rNfx4TyIBxdFOICTNYdSwlpOl/O0ZyrMQyXehRZRbMAN6XmGJjtOGB9wAl3pTkdk8VJ1vMpG9f2SwR0LVSuO01I6tmxKuAOBZt7AJM0PFtYs7PbTJh/XsoBZv2gKVNbRTjdJ0h1NpW+xU9HDZ9H1tpeoIq4bAgi+Y7B31fGJSSpivu/dNOfz2T5IYAeXG+kGr9joVBqkbctedh8meQlu2wZEA/ms//WsD0QRU49yOZDq2C7DMfPyEEhBYJkiC/Ajqj+mOfAiUI0vtjRA/fhVb/VZH5ITN43veEc8Qc="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQpO6feXcBptGjtcVPii+jjxumAdpMyYc633abLKlq93FSIWmsP9pZC30NG2XrcTgM6eFOgeWM/aIFN2kAd9Ec8yVdJ2wQHtSB2rrqStfg6edh3BEASuwO08VJGHu9peX850MEtd7A4uL+yrtAsMCJdk63MVctS9ePhNzDZL288j559rLrG/qSRlEyiF2bjtJJL+nZKX94P3aIwtV7Q9fK00gaooipl5We+B/VLfv+pCH/V8PcuqFxlgRzNonJWiA6l3yWtnkjKB/cvRc0FlJwj2T/SbGg33+l6AeT7k9jn3DQi//puyWTO5JuyTISywjMekWBOtSUrXUyoNxynCb3laVblcSj4646X+ywpBWXoaomtLBDZsG40Q04ja+jkFItSo8lrvHbY1rHLWsFUVonbi7EcsBMETmAmzlmlkUmui4jFV8dOE4h8xqml7CAxWT5DLvIgsNs5cOXdLCQr5/4DGBYi1Idk0wU+R3CAoPI46pvyOo47fQBh3twx/l8NS0="
  ];
}
