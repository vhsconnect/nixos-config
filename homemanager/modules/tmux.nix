{ pkgs, user, ... }:

let
  theme = import (../themes/. + "/${user.theme}.nix");
in
with theme;
{

  programs.tmux.enable = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.extraConfig = ''
    # No delay in Vim
    set -s escape-time 0

    # remap prefix from accessing tmux commands
    unbind C-b
    set-option -g prefix C-a
    bind-key C-a send-prefix

    # remap splits
    # split panes using | and -
    bind | split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

    # navigate-panes
    #bind -n M-Left select-pane -L
    #bind -n M-Right select-pane -R
    #bind -n M-Up select-pane -U
    #bind -n M-Down select-pane -D
    #bind -n M-Space select-pane -t :.+

    # Reload config
    bind r source-file ~/.tmux.conf

    # Enable mouse control
    set -g mouse on
    bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
    bind -n WheelDownPane select-pane -t= \; send-keys -M

    # Display
    set -g base-index 1
    set -g pane-base-index 1
    set-option -g visual-activity on
    set-window-option -g monitor-activity on

    # Current window should stand out
    set -g window-status-current-style fg=green,bg=black


    # vi mode
    set-window-option -g mode-keys vi

    # alternate pane navigation
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    bind-key -n 'C-h' if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
    bind-key -n 'C-j' if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
    bind-key -n 'C-k' if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
    bind-key -n 'C-l' if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
    bind-key -T copy-mode-vi C-h select-pane -L
    bind-key -T copy-mode-vi C-j select-pane -D
    bind-key -T copy-mode-vi C-k select-pane -U
    bind-key -T copy-mode-vi C-l select-pane -R

  '';
  programs.tmux.plugins = [
    {
      plugin = pkgs.tmuxPlugins.tmux-thumbs;
      extraConfig = ''
        set -g @thumbs-key f
        set -g @thumbs-command 'echo -n {} | wl-copy'

        # set -g @thumbs-fg-color '#e5e1e9'
        # set -g @thumbs-bg-color '#434078'
        # set -g @thumbs-hint-fg-color '#ebb9d0'
        # set -g @thumbs-hint-bg-color '#434078'

        # High contrast color scheme using hex values
        # Background: Dark navy (${secondary}) for better contrast
        # Text colors: Bright whites and colors for maximum readability

        # Status bar background and foreground (idle state)
        set -g status-style "bg=${secondary},fg=${main}"

        # Left side of status bar (session info)
        set -g status-left-length 50
        set -g status-left-style "bg=${accent},fg=${main},bold"
        set -g status-left " #S "

        # Right side of status bar (time, load, etc.)
        set -g status-right-length 80
        set -g status-right-style "bg=${accent},fg=${main}"
        set -g status-right " %Y-%m-%d %H:%M "

        # Window status formats
        # Default window (inactive)
        set -g window-status-style "bg=${secondary},fg=${accent2}"
        set -g window-status-format " #I:#W "

        # Current/active window
        set -g window-status-current-style "bg=#{main},fg=${secondary},bold"
        set -g window-status-current-format " #I:#W "

        # Activity/bell states (high contrast warnings)
        set -g window-status-activity-style "bg=#ff6b35,fg=${main},bold"
        set -g window-status-bell-style "bg=#ff1744,fg=${main},bold,blink"

        # Command line colors (when typing commands)
        set -g message-style "bg=${main},fg=${secondary},bold"
        set -g message-command-style "bg=#ffeb3b,fg=${secondary},bold"

        # Pane border colors
        set -g pane-border-style "fg=#4a5568"
        set -g pane-active-border-style "fg=${main},bold"

        # Copy mode colors (when in copy mode)
        set -g mode-style "bg=#4caf50,fg=${main},bold"

        # Clock mode colors (Ctrl-b t)
        set -g clock-mode-colour "${accent2}"
        set -g clock-mode-style 24

        # Additional high-contrast states
        # These cover various tmux states and modes

        # Pane selection indicator
        set -g display-panes-colour "#ffeb3b"
        set -g display-panes-active-colour "#ff6b35"
        set -g display-panes-time 2000

        # Search highlighting in copy mode
        set -g copy-mode-match-style "bg=#ff6b35,fg=${main}"
        set -g copy-mode-current-match-style "bg=#ff1744,fg=${main},bold"


        # Synchronized panes indicator (when panes are synchronized)
        set -g window-status-format "#{?synchronize-panes,#[bg=#ff6b35]#[fg=${main}]#[bold] SYNC ,} #I:#W "
        set -g window-status-current-format "#{?synchronize-panes,#[bg=#ff1744]#[fg=${main}]#[bold] SYNC ,}#[bg=${main}]#[fg=${secondary}]#[bold] #I:#W "

        # Enable activity monitoring for visual feedback
        set -g monitor-activity on
        set -g visual-activity off  # Don't show messages, just use colors
        set -g monitor-bell on
        set -g visual-bell off

        # Color summary for reference:
        # Background (idle): ${secondary} (dark navy)
        # Foreground text: ${main} (white)
        # Active elements: ${main} background, ${secondary} text (inverted)
        # Warning/activity: #ff6b35 (bright orange)
        # Critical/bell: #ff1744 (bright red)
        # Special states: #ffeb3b (bright yellow), #4caf50 (green), #6a1b9a (purple)
        # Accent/borders: ${accent} (blue), #4a5568 (gray)

        # Optional: Enable true color support if your terminal supports it
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ",*256col*:Tc"

      '';

    }
  ];
}
