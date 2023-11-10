{ pkgs, ... }: {
  xdg.configFile."terminator/configbackup".text = ''
        cursor_color = "#aaaaaa"
        show_titlebar = False
      [[dark]]
        background_darkness = 0.7
        background_type = transparent
        cursor_color = "#aaaaaa"
        font = VictorMono Nerd Font 13
        foreground_color = "#00ff00"
        show_titlebar = False
        scrollback_infinite = True
        palette = "#000000:#f731ac:#3cf04c:#ff7800:#596ab2:#b920da:#74c074:#faebd7:#404040:#ff0000:#00ff00:#efec27:#2c99fd:#c0bfbc:#00ffff:#ffffff"
        use_system_font = False
        copy_on_selection = True
      [[light]]
        background_color = "#fbf8f0"
        cursor_color = "#aaaaaa"
        font = Iosevka Term Medium 13
        foreground_color = "#000000"
        show_titlebar = False
        scrollback_infinite = True
        palette = "#000000:#cd0000:#00cd00:#cdcd00:#0000cd:#cd00cd:#00cdcd:#77767b:#404040:#ff0000:#00ff00:#ffff00:#0000ff:#ff00ff:#00ffff:#c0bfbc"
        use_system_font = False
        copy_on_selection = True
      [[dark2]]
        cursor_color = "#aaaaaa"
        font = Hack Nerd Font 12
        foreground_color = "#00ff00"
        show_titlebar = False
        palette = "#2e3436:#e65252:#4e9a06:#c4a000:#3465a4:#75507b:#06989a:#d3d7cf:#555753:#ff7800:#8ae234:#fce94f:#729fcf:#ad7fa8:#34e2e2:#eeeeec"
        use_system_font = False
    [layouts]
      [[default]]
        [[[window0]]]
          type = Window
          parent = ""
        [[[child1]]]
          type = Terminal
          parent = window0
          profile = dark
    [plugins]
  '';
}
