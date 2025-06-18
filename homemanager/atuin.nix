{ ... }:
{

  programs.atuin = {
    enable = false;
    enableZshIntegration = true;

    flags = [
      "--disable-up-arrow"
      "--disable-ctrl-r"
    ];
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
      style = "compact";
      store_failed = false;
      secrets_filter = false;

    };
  };
  # programs.zsh.initExtra = ''
  #   export ATUIN_NOBIND="true"
  #   eval "$(atuin init zsh)"
  #
  #   bindkey '^e' atuin-search
  # '';
}
