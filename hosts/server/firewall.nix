{...}: {
  # The host currently relies on the provider firewall rather than an INPUT
  # deny policy. Enable a host firewall only after reviewing every listener and
  # the corresponding provider rule.
  networking.firewall = {
    enable = false;
    checkReversePath = false;
  };
}
