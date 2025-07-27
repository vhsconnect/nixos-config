#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused
#/* vim: set filetype=bash : */

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
    sed -i "/config\/alacritty\/fonts/c\\$Y" ~/.config/alacritty/alacritty.toml

    echo $font_qualified_name

    AVAILABLE_STYLES=$(fc-list | grep "$font_qualified_name" | grep -o 'style=.*' | cut -d= -f2 | tr ',' '\n' | sort | uniq)


    NORMAL=$(echo "$AVAILABLE_STYLES" | fzf --header 'style NORMAL')
    BOLD=$(echo "$AVAILABLE_STYLES" | fzf --header 'style BOLD')
    ITALIC=$(echo "$AVAILABLE_STYLES" | fzf --header 'style ITALIC')
    BOLD_ITALIC=$(echo "$AVAILABLE_STYLES" | fzf --header 'style BOLD ITALIC')

    SN="style = \"$NORMAL\""
    SB="style = \"$BOLD\""
    SI="style = \"$ITALIC\""
    SBI="style = \"$BOLD_ITALIC\""

    sed -i "/^style = /c\\$SN" ~/.config/alacritty/font-styles/normal.toml
    sed -i "/^style = /c\\$SB" ~/.config/alacritty/font-styles/bold.toml
    sed -i "/^style = /c\\$SI" ~/.config/alacritty/font-styles/italic.toml
    sed -i "/^style = /c\\$SBI" ~/.config/alacritty/font-styles/bold-italic.toml

elif [ "$TYPE" = "themes" ]; then
    if [ -n "$PICK" ]; then
        selected_option="$PICK"
    else
        options=($(ls ~/.config/alacritty/themes/themes/))
        selected_option=$(printf '%s\n' "${options[@]}" | fzf)
    fi
    echo "$selected_option"
    Y="\"~/.config/alacritty/themes/themes/$selected_option\","
    sed -i "/config\/alacritty\/themes\/themes/c\\$Y" ~/.config/alacritty/alacritty.toml
fi



