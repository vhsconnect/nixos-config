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
    selected_option+=.toml

    Y="\"~/.config/alacritty/fonts/$selected_option\""
    sed -i "/config\/alacritty\/fonts/c\\$Y" ~/.config/alacritty/alacritty.toml
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



