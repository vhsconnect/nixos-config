{
  pkgs,
  user,
  ...
}: let
  zstuff = pkgs.writeTextDir "home/vhs/Public/templates/.zstuff" ''
    #vim=bash
    export BAT_THEME=ansi

    DARK_FZF_TAB="fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

    LIGHT_FZF_TAB="fg:#4d4d4c,bg:#eeeeee,hl:#d7005f,fg+:#4d4d4c,bg+:#e8e8e8,hl+:#d7005f,info:#4271ae,prompt:#8959a8,pointer:#d7005f,marker:#4271ae,spinner:#4271ae,header:#4271ae"

    zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
    zstyle ":fzf-tab:*" \
    fzf-flags \
    --border \
    --color $DARK_FZF_TAB
  '';
in {
  home.packages = [
    zstuff
  ];
}
