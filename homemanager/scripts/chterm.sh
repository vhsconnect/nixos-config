#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused fzf fontconfig

set -e
usage() { echo "Usage: $0 [-f|-t] [--pick=selection] string_list"; exit 1; }
TYPE="fonts" 
PICK=""

for arg in "$@"; do
    case "$arg" in
        --pick=*)
            PICK="${arg#*=}"
            shift
            ;;
    esac
done

while getopts "ft" opt; do
    case $opt in
        f) TYPE="fonts" ;;
        t) TYPE="themes" ;;
        *) usage ;;
    esac
done
shift $((OPTIND-1))

sanitize_style_path() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}

if [ "$TYPE" = "fonts" ]; then
    if [ $# -lt 1 ]; then
        echo "Error: Missing required string list argument"
        echo "Usage: $0 [-f|-t] string_list"
        exit 1
    fi
    if [ -n "$PICK" ]; then
        selected_option="$PICK"
    else
        options=($1)
        selected_option=$(printf '%s\n' "${options[@]}" | fzf --height 70% )
    fi

    font_path=$(echo "$selected_option" | awk -F: '{print $1}')
    font_qualified_name=$(echo "$selected_option" | awk -F: '{print $2}')
    selected_option_path="$font_path.toml"

    Y="\"~/.config/alacritty/fonts/$selected_option_path\","
    sed -i "/config\/alacritty\/fonts/c\\  $Y" ~/.config/alacritty/alacritty.toml

    echo "Switched to Family: $font_qualified_name"

    AVAILABLE_STYLES=$(fc-list | grep "$font_qualified_name" | grep -o 'style=.*' | cut -d= -f2 | tr ',' '\n' | sort | uniq)

    NORMAL=$(echo "$AVAILABLE_STYLES" | fzf --header 'style NORMAL')
    BOLD=$(echo "$AVAILABLE_STYLES" | fzf --header 'style BOLD')
    ITALIC=$(echo "$AVAILABLE_STYLES" | fzf --header 'style ITALIC')
    BOLD_ITALIC=$(echo "$AVAILABLE_STYLES" | fzf --header 'style BOLD ITALIC')

    PATH_NORMAL=$(sanitize_style_path "$NORMAL")
    PATH_BOLD=$(sanitize_style_path "$BOLD")
    PATH_ITALIC=$(sanitize_style_path "$ITALIC")
    PATH_BOLD_ITALIC=$(sanitize_style_path "$BOLD_ITALIC")

    sed -i "/config\/alacritty\/font-styles\/normal-/c\\  \"~/.config/alacritty/font-styles/normal-$PATH_NORMAL.toml\"," ~/.config/alacritty/alacritty.toml
    sed -i "/config\/alacritty\/font-styles\/bold-/c\\  \"~/.config/alacritty/font-styles/bold-$PATH_BOLD.toml\"," ~/.config/alacritty/alacritty.toml
    sed -i "/config\/alacritty\/font-styles\/italic-/c\\  \"~/.config/alacritty/font-styles/italic-$PATH_ITALIC.toml\"," ~/.config/alacritty/alacritty.toml
    sed -i "/config\/alacritty\/font-styles\/bold_italic-/c\\  \"~/.config/alacritty/font-styles/bold_italic-$PATH_BOLD_ITALIC.toml\"," ~/.config/alacritty/alacritty.toml

elif [ "$TYPE" = "themes" ]; then
    if [ -n "$PICK" ]; then
        selected_option="$PICK"
    else
        options=($(ls ~/.config/alacritty/themes/))
        selected_option=$(printf '%s\n' "${options[@]}" | fzf)
    fi
    echo "$selected_option"
    Y="\"~/.config/alacritty/themes/$selected_option\","
    sed -i "/config\/alacritty\/themes/c\\  $Y" ~/.config/alacritty/alacritty.toml
fi
