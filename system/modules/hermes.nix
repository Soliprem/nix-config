{
  config,
  inputs,
  ...
}: {
  imports = [inputs.hermes-agent.nixosModules.default];

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    # Keep the sealed Nix build practical: Telegram/Discord/Slack gateway deps,
    # plus Hindsight memory. Matrix is deliberately omitted because its client
    # stack, especially encryption, is heavier.
    extraDependencyGroups = ["hindsight" "messaging"];

    environmentFiles = [config.age.secrets.hermes_env.path];

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.5";
      };

      terminal = {
        backend = "local";
        cwd = "/var/lib/hermes/workspace";
        timeout = 180;
      };

      memory = {
        provider = "hindsight";
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };
  };
}
