{ pkgs, ... }:
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
        set -g @thumbs-fg-color '#e5e1e9'
        set -g @thumbs-bg-color '#434078'
        set -g @thumbs-hint-fg-color '#ebb9d0'
        set -g @thumbs-hint-bg-color '#434078'
      '';
    }
  ];
}
