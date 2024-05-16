{ pkgs
, user
, ...
}:
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

  alacritty_yaml = pkgs.writeTextDir "home/vhs/Public/templates/alacritty.yml" ''
    window:
      dimensions:
        columns: 100
        lines: 85
      padding:
        x: 3
        y: 3
      dynamic_padding: false
      decorations: none
      startup_mode: Windowed
      opacity: 0.85
    scrolling:
      history: 10000
      multiplier: 3
    font:
      size: 12
      normal:
        family: Iosevka Nerd Font
        style: Light
      bold:
        family: Iosevka Nerd Font
        style: Italic
      italic:
        family: VictorMono Nerd Font
        style: Bold Italic
      offset:
        x: 0
        y: 0
      glyph_offset:
        x: 0
        y: 0
    draw_bold_text_with_bright_colors: true
    custom_cursor_colors: true
    schemes:
      tokyo-night: &tokyo-night # Default colors
        primary:
          background: "#1a1b26"
          foreground: "#a9b1d6"

        # Normal colors
        normal:
          black: "#32344a"
          red: "#f7768e"
          green: "#9ece6a"
          yellow: "#e0af68"
          blue: "#7aa2f7"
          magenta: "#ad8ee6"
          cyan: "#449dab"
          white: "#787c99"

        # Bright colors
        bright:
          black: "#444b6a"
          red: "#ff7a93"
          green: "#b9f27c"
          yellow: "#ff9e64"
          blue: "#7da6ff"
          magenta: "#bb9af7"
          cyan: "#0db9d7"
          white: "#acb0d0"

      tokyo-night-moon: &tokyo-night-moon
        primary:
          background: "0x222436"
          foreground: "0xc8d3f5"

        normal:
          black: "0x1b1d2b"
          red: "0xff757f"
          green: "0xc3e88d"
          yellow: "0xffc777"
          blue: "0x82aaff"
          magenta: "0xc099ff"
          cyan: "0x86e1fc"
          white: "0x828bb8"

        bright:
          black: "0x444a73"
          red: "0xff757f"
          green: "0xc3e88d"
          yellow: "0xffc777"
          blue: "0x82aaff"
          magenta: "0xc099ff"
          cyan: "0x86e1fc"
          white: "0xc8d3f5"

      gruvbox-dark: &gruvbox
        primary:
          background: "0x282828"
          foreground: "0xdfbf8e"

        normal:
          black: "0x665c54"
          red: "0xea6962"
          green: "0xa9b665"
          yellow: "0xe78a4e"
          blue: "0x7daea3"
          magenta: "0xd3869b"
          cyan: "0x89b482"
          white: "0xdfbf8e"

        bright:
          black: "0x928374"
          red: "0xea6962"
          green: "0xa9b665"
          yellow: "0xe3a84e"
          blue: "0x7daea3"
          magenta: "0xd3869b"
          cyan: "0x89b482"
          white: "0xdfbf8e"
      dracula: &dracula
        primary:
          background: "#282a36"
          foreground: "#f8f8f2"

        # Normal colors
        normal:
          black: "#000000"
          red: "#ff5555"
          green: "#50fa7b"
          yellow: "#f1fa8c"
          blue: "#caa9fa"
          magenta: "#ff79c6"
          cyan: "#8be9fd"
          white: "#bfbfbf"

        # Bright colors
        bright:
          black: "#575b70"
          red: "#ff6e67"
          green: "#5af78e"
          yellow: "#f4f99d"
          blue: "#caa9fa"
          magenta: "#ff92d0"
          cyan: "#9aedfe"
          white: "#e6e6e6"

      spacemacs: &spacemacs #light
        primary:
          foreground: "#64526F"
          background: "#FAF7EE"

        cursor:
          cursor: "#64526F"
          text: "#FAF7EE"
        normal:
          black: "#FAF7EE"
          red: "#DF201C"
          green: "#29A0AD"
          yellow: "#DB742E"
          blue: "#3980C2"
          magenta: "#2C9473"
          cyan: "#6B3062"
          white: "#64526F"

        bright:
          black: "#9F93A1"
          red: "#DF201C"
          green: "#29A0AD"
          yellow: "#DB742E"
          blue: "#3980C2"
          magenta: "#2C9473"
          cyan: "#6B3062"
          white: "#64526F"

      taerminal: &taerminal
        primary:
          background: "0x26282a"
          foreground: "0xf0f0f0"
        cursor:
          background: "0xf0f0f0"
          foreground: "0x26282a"

        # Normal colors
        normal:
          black: "0x26282a"
          red: "0xff8878"
          green: "0xb4fb73"
          yellow: "0xfffcb7"
          blue: "0x8bbce5"
          magenta: "0xffb2fe"
          cyan: "0xa2e1f8"
          white: "0xf1f1f1"

        # Bright colors
        bight:
          black: "0x6f6f6f"
          red: "0xfe978b"
          green: "0xd6fcba"
          yellow: "0xfffed5"
          blue: "0xc2e3ff"
          magenta: "0xffc6ff"
          cyan: "0xc0e9f8"
          white: "0xffffff"

      gruvbox-light: &gruvbox-light
        primary:
          # hard contrast: background = '0xf9f5d7'
          background: "0xfbf1c7"
          # soft contrast: background = '0xf2e5bc'
          foreground: "0x3c3836"

        # Normal colors
        normal:
          black: "0xfbf1c7"
          red: "0xcc241d"
          green: "0x98971a"
          yellow: "0xd79921"
          blue: "0x458588"
          magenta: "0xb16286"
          cyan: "0x689d6a"
          white: "0x7c6f64"

        # Bright colors
        bright:
          black: "0x928374"
          red: "0x9d0006"
          green: "0x79740e"
          yellow: "0xb57614"
          blue: "0x076678"
          magenta: "0x8f3f71"
          cyan: "0x427b58"
          white: "0x3c3836"

      carrots: &carrots
        primary:
          background: "#f7f7f7"
          foreground: "#4a4543"
        cursor:
          text: "#f7f7f7"
          cursor: "#4a4543"
        normal:
          black: "#090300"
          red: "#db2d20"
          green: "#01a252"
          yellow: "#ef803b"
          blue: "#2d579e"
          magenta: "#a16a94"
          cyan: "#6c6fd8"
          white: "#4a4543"
        bright:
          black: "#5c5855"
          red: "#db2d20"
          green: "#01a252"
          yellow: "#ef803b"
          blue: "#2d579e"
          magenta: "#a16a94"
          cyan: "#6c6fd8"
          white: "#4a4543"

    colors: *tokyo-night-moon

    # Key bindings
    #
    # Key bindings are specified as a list of objects. Each binding will specify a
    # key and modifiers required to trigger it, terminal modes where the binding is
    # applicable, and what should be done when the key binding fires. It can either
    # send a byte sequence to the running application (`chars`), execute a
    # predefined action (`action`) or fork and execute a specified command plus
    # arguments (`command`).
    #
    # Bindings are always filled by default, but will be replaced when a new binding
    # with the same triggers is defined. To unset a default binding, it can be
    # mapped to the `None` action.
    #
    # Example:
    #   `- { key: V, mods: Control|Shift, action: Paste }`
    #
    # Available fields:
    #   - key
    #   - mods (optional)
    #   - chars | action | command (exactly one required)
    #   - mode (optional)
    #
    # Values for `key`:
    #   - `A` -> `Z`
    #   - `F1` -> `F12`
    #   - `Key1` -> `Key0`
    #
    #   A full list with available key codes can be found here:
    #   https://docs.rs/glutin/*/glutin/enum.VirtualKeyCode.html#variants
    #
    #   Instead of using the name of the keys, the `key` field also supports using
    #   the scancode of the desired key. Scancodes have to be specified as a
    #   decimal number.
    #   This command will allow you to display the hex scancodes for certain keys:
    #     `showkey --scancodes`
    #
    # Values for `mods`:
    #   - Command
    #   - Control
    #   - Option
    #   - Super
    #   - Shift
    #   - Alt
    #
    #   Multiple `mods` can be combined using `|` like this: `mods: Control|Shift`.
    #   Whitespace and capitalization is relevant and must match the example.
    #
    # Values for `chars`:
    #   The `chars` field writes the specified string to the terminal. This makes
    #   it possible to pass escape sequences.
    #   To find escape codes for bindings like `PageUp` ("\x1b[5~"), you can run
    #   the command `showkey -a` outside of tmux.
    #   Note that applications use terminfo to map escape sequences back to
    #   keys. It is therefore required to update the terminfo when
    #   changing an escape sequence.
    #
    # Values for `action`:
    #   - Paste
    #   - PasteSelection
    #   - Copy
    #   - IncreaseFontSize
    #   - DecreaseFontSize
    #   - ResetFontSize
    #   - ScrollPageUp
    #   - ScrollPageDown
    #   - ScrollLineUp
    #   - ScrollLineDown
    #   - ScrollToTop
    #   - ScrollToBottom
    #   - ClearHistory
    #   - Hide
    #   - Quit
    #   - ClearLogNotice
    #   - SpawnNewInstance
    #   - ToggleFullscreen
    #   - None
    #
    # Values for `action` (macOS only):
    #   - ToggleSimpleFullscreen: Enters fullscreen without occupying another space
    #
    # Values for `command`:
    #   The `command` field must be a map containing a `program` string and
    #   an `args` array of command line parameter strings.
    #
    #   Example:
    #       `command: { program: "alacritty", args: ["-e", "vttest"] }`
    #
    # Values for `mode`:
    #   - ~AppCursor
    #   - AppCursor
    #   - ~AppKeypad
    #   - AppKeypad
    #
    # key_bindings:
    #   - { key: V,        mods: Command,       action: Paste                        }
    #   - { key: C,        mods: Command,       action: Copy                         }
    #   - { key: Q,        mods: Command,       action: Quit                         }
    #   - { key: N,        mods: Command,       action: SpawnNewInstance             }
    #   - { key: Return,   mods: Command,       action: ToggleFullscreen             }
    #
    #   - { key: Home,                          chars: "\x1bOH",   mode: AppCursor   }
    #   - { key: Home,                          chars: "\x1b[H",   mode: ~AppCursor  }
    #   - { key: End,                           chars: "\x1bOF",   mode: AppCursor   }
    #   - { key: End,                           chars: "\x1b[F",   mode: ~AppCursor  }
    #   - { key: Equals,   mods: Command,       action: IncreaseFontSize             }
    #   - { key: Minus,    mods: Command,       action: DecreaseFontSize             }
    #   - { key: Minus,    mods: Command|Shift, action: ResetFontSize                }
    #   - { key: PageUp,   mods: Shift,         chars: "\x1b[5;2~"                   }
    #   - { key: PageUp,   mods: Control,       chars: "\x1b[5;5~"                   }
    #   - { key: PageUp,                        chars: "\x1b[5~"                     }
    #   - { key: PageDown, mods: Shift,         chars: "\x1b[6;2~"                   }
    #   - { key: PageDown, mods: Control,       chars: "\x1b[6;5~"                   }
    #   - { key: PageDown,                      chars: "\x1b[6~"                     }
    #   - { key: Left,     mods: Shift,         chars: "\x1b[1;2D"                   }
    #   - { key: Left,     mods: Control,       chars: "\x1b[1;5D"                   }
    #   - { key: Left,     mods: Alt,           chars: "\x1b[1;3D"                   }
    #   - { key: Left,                          chars: "\x1b[D",   mode: ~AppCursor  }
    #   - { key: Left,                          chars: "\x1bOD",   mode: AppCursor   }
    #   - { key: Right,    mods: Shift,         chars: "\x1b[1;2C"                   }
    #   - { key: Right,    mods: Control,       chars: "\x1b[1;5C"                   }
    #   - { key: Right,    mods: Alt,           chars: "\x1b[1;3C"                   }
    #   - { key: Right,                         chars: "\x1b[C",   mode: ~AppCursor  }
    #   - { key: Right,                         chars: "\x1bOC",   mode: AppCursor   }
    #   - { key: Up,       mods: Shift,         chars: "\x1b[1;2A"                   }
    #   - { key: Up,       mods: Control,       chars: "\x1b[1;5A"                   }
    #   - { key: Up,       mods: Alt,           chars: "\x1b[1;3A"                   }
    #   - { key: Up,                            chars: "\x1b[A",   mode: ~AppCursor  }
    #   - { key: Up,                            chars: "\x1bOA",   mode: AppCursor   }
    #   - { key: Down,     mods: Shift,         chars: "\x1b[1;2B"                   }
    #   - { key: Down,     mods: Control,       chars: "\x1b[1;5B"                   }
    #   - { key: Down,     mods: Alt,           chars: "\x1b[1;3B"                   }
    #   - { key: Down,                          chars: "\x1b[B",   mode: ~AppCursor  }
    #   - { key: Down,                          chars: "\x1bOB",   mode: AppCursor   }
    #   - { key: Tab,      mods: Shift,         chars: "\x1b[Z"                      }
    #   - { key: F1,                            chars: "\x1bOP"                      }
    #   - { key: F2,                            chars: "\x1bOQ"                      }
    #   - { key: F3,                            chars: "\x1bOR"                      }
    #   - { key: F4,                            chars: "\x1bOS"                      }
    #   - { key: F5,                            chars: "\x1b[15~"                    }
    #   - { key: F6,                            chars: "\x1b[17~"                    }
    #   - { key: F7,                            chars: "\x1b[18~"                    }
    #   - { key: F8,                            chars: "\x1b[19~"                    }
    #   - { key: F9,                            chars: "\x1b[20~"                    }
    #   - { key: F10,                           chars: "\x1b[21~"                    }
    #   - { key: F11,                           chars: "\x1b[23~"                    }
    #   - { key: F12,                           chars: "\x1b[24~"                    }
    #   - { key: Back,                          chars: "\x7f"                        }
    #   - { key: Back,     mods: Alt,           chars: "\x1b\x7f"                    }
    #   - { key: Insert,                        chars: "\x1b[2~"                     }
    #   - { key: Delete,                        chars: "\x1b[3~"                     }
    #
    #     # shortcuts for tmux. the leader key is control-b (0x02)
    #   - { key: W,        mods: Command,       chars: "\x02&"                       }  # close tab (kill)
    #   - { key: T,        mods: Command,       chars: "\x02c"                       }  # new tab
    #   - { key: RBracket, mods: Command|Shift, chars: "\x02n"                       }  # select next tab
    #   - { key: LBracket, mods: Command|Shift, chars: "\x02p"                       }  # select previous tab
    #   - { key: RBracket, mods: Command,       chars: "\x02o"                       }  # select next pane
    #   - { key: LBracket, mods: Command,       chars: "\x02;"                       }  # select last (previously used) pane
    #   - { key: F,        mods: Command,       chars: "\x02/"                       }  # search (upwards) (see tmux.conf)

    mouse:
      double_click: { threshold: 300 }
      triple_click: { threshold: 300 }
      hide_when_typing: true

    selection:
      save_to_clipboard: true
        mouse_bindings:
          - {
            mouse: Middle, action: PasteSelection }

            cursor:
            #   - ▇ Block
            #   - _ Underline
            #   - | Beam
            style:
            shape: Underline
            blinking: Always
            unfocused_hollow: true
            blink_interval: 1000
            vi_mode_style:
            shape: Block
            live_config_reload: true
            debug:
            # Should display the render timer
            render_timer: false
            # Keep the log file after quitting Alacritty.
            persistent_logging: false
            # Log level
            #   - OFF
            #   - ERROR
            #   - WARN
            #   - INFO
            #   - DEBUG
            #   - TRACE
            log_level: OFF
            print_events: false
            ref_test: false
            # vim: nospell

  '';
in
{
  home.packages = [
    zstuff
    alacritty
  ];
}

