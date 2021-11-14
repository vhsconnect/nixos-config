{ pkgs, lib, ... }:
let
  theme = (import ./themes/current.nix).theme;
in
{
  xdg.configFile."rofi/rofi-theme.rasi".text = ''

    configuration {
      display-run: "> ";
      show-icons: true;
      icon-theme: "Paper";
    }

    *{
        main:           ${theme.main};
        bg-highlight:   ${theme.secondary};
        fg-highlight:   ${theme.accent3};
        bg-normal:      ${theme.main};
        fg-normal:      ${theme.secondary};
        fallback:       ${theme.debug};
        fallback2:      ${theme.debug};
        border:         ${theme.accent3};
        transparent:     rgba ( 0, 0, 0, 0 % );

        normal-foreground:           @bg-highlight;
        normal-background:           @transparent;
        active-foreground:           @fallback;
        active-background:           @transparent;
        urgent-foreground:           @red;
        urgent-background:           @transparent;

        selected-normal-foreground:  @fg-highlight;
        selected-normal-background:  @bg-highlight;
        selected-active-foreground:  @fallback;
        selected-active-background:  @bg-highlight;
        selected-urgent-foreground:  @fallback;
        selected-urgent-background:  @fallback2;

        alternate-normal-foreground: @bg-highlight;
        alternate-normal-background: @transparent;
        alternate-active-foreground: @active-foreground;
        alternate-active-background: @transparent;
        alternate-urgent-foreground: @urgent-foreground;
        alternate-urgent-background: @transparent;

        spacing:                     2;
        background-color:            @transparent;
    }

    window {
        background-color: @main;
        border:           1;
        padding:          20;
    }

    mainbox {
        border:  0;
        padding: 0;
    }
    message {
        border:       1px dash 0px 0px ;
        border-color: @border;
        padding:      1px ;
        font: "Iosevka Medium 15";
    }
    textbox {
        text-color: @border;
    }
    listview {
        fixed-height: 0;
        border:       1px dash 0px 0px ;
        border-color: @border;
        lines: 5;
        spacing:      2px ;
        scrollbar:    false;
        padding:      8px 0px 0px 0px;
        max-history-size: 3;
    }
    element {
        border:  0;
        padding: 1px 0px 1px 1px;
    }
    element normal.normal {
        background-color: @bg-normal;
        text-color:       @fg-normal;
    }
    element normal.urgent {
        background-color: @urgent-background;
        text-color:       @urgent-foreground;
    }
    element normal.active {
        background-color: @active-background;
        text-color:       @active-foreground;
    }
    element selected.normal {
        background-color: @selected-normal-background;
        text-color:       @selected-normal-foreground;
    }
    element selected.urgent {
        background-color: @selected-urgent-background;
        text-color:       @selected-urgent-foreground;
    }
    element selected.active {
        background-color: @selected-active-background;
        text-color:       @selected-active-foreground;
    }
    element alternate.normal {
        background-color: @alternate-normal-background;
        text-color:       @alternate-normal-foreground;
    }
    element alternate.urgent {
        background-color: @alternate-urgent-background;
        text-color:       @alternate-urgent-foreground;
    }
    element alternate.active {
        background-color: @alternate-active-background;
        text-color:       @alternate-active-foreground;
    }
    scrollbar {
        width:        4px ;
        border:       0;
        handle-width: 8px ;
        padding:      0;
    }
    inputbar {
        spacing:    0;
        text-color: @fg-normal;
        padding:    1px ;
    }
    case-indicator {
        spacing:    0;
        text-color: @fg-normal;
    }
    entry {
        spacing:    0;
        text-color: @fg-normal;
    }
    prompt {
        spacing:    0;
        text-color: @fg-normal;
    }
    mode-switcher {
        orientation: vertical;
        expand:      false;
        spacing:     0px ;
        border:      0px ;
    }
    button {
        text-color:       @fallback;
        padding:          6px ;
        background-color: @red;
        border-radius:    4px 0px 0px 4px ;
        font:             "FontAwesome 5";
        border:           2px 0px 2px 2px ;
        horizontal-align: 0.50;
        border-color:     @red;
    }
    button selected.normal {
        background-color: @red;
        border-color:     @red;
        text-color:       @fallback;
        border:           2px 0px 2px 2px ;
    }'';
}