{...}: {
  # Debian currently has no host INPUT deny policy. Keep first-boot behavior
  # compatible until the full listener/provider-firewall matrix is reviewed;
  # do not substitute the stale 22/80/443/8448-only rule set.
  networking.firewall = {
    enable = false;
    checkReversePath = false;
  };
}
