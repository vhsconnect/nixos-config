{ pkgs, user, ... }:
let
  zstuff = pkgs.writeTextDir "home/vhs/Public/templates/.zstuff" ''
    #vim=bash
    #! /usr/bin/env bash

    export BAT_THEME=ansi
    export VIM_THEME=gruvbox

    DARK_FZF_TAB="fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

    LIGHT_FZF_TAB="fg:#4d4d4c,bg:#eeeeee,hl:#d7005f,fg+:#4d4d4c,bg+:#e8e8e8,hl+:#d7005f,info:#4271ae,prompt:#8959a8,pointer:#d7005f,marker:#4271ae,spinner:#4271ae,header:#4271ae"


    export FZF_DEFAULT_OPTS=" --color $DARK_FZF_TAB"

    zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
    zstyle ":fzf-tab:*" \
    fzf-flags --color $DARK_FZF_TAB

  '';

  alacritty_toml = pkgs.writeTextDir "home/vhs/Public/templates/alacritty_toml" ''

    import = [
        "~/.config/alacritty/themes/themes/tokyo-night-storm.toml"
    ]

    live_config_reload = true

    [cursor]
    blink_interval = 1000
    unfocused_hollow = true

    [cursor.style]
    blinking = "Always"
    shape = "Underline"

    [cursor.vi_mode_style]
    shape = "Block"

    [debug]
    log_level = "OFF"
    persistent_logging = false
    print_events = false
    render_timer = false

    [font]
    size = 12

    [font.bold]
    family = "VictorMono Nerd Font"
    style = "Italic"

    [font.glyph_offset]
    x = 0
    y = 0

    [font.italic]
    family = "VictorMono Nerd Font"
    style = "Light Italic"

    [font.normal]
    family = "Iosevka Nerd Font"
    style = "Medium"

    [font.offset]
    x = 0
    y = 0

    [mouse]
    hide_when_typing = true

    [[mouse.bindings]]
    action = "PasteSelection"
    mouse = "Middle"

    [scrolling]
    history = 10000
    multiplier = 3

    [selection]
    save_to_clipboard = true
    semantic_escape_chars = ",│`|:\"' ()[]{}<>"

    [window]
    decorations = "none"
    dynamic_padding = false
    opacity = 0.85
    startup_mode = "Windowed"

    [window.dimensions]
    columns = 100
    lines = 85

    [window.padding]
    x = 3
    y = 3
  '';
in
{
  home.packages = [
    zstuff
    alacritty_toml
  ];
}
