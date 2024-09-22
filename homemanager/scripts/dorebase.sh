#!/usr/bin/env bash

get_conflicted_files() {
    git diff --name-only --diff-filter=U
}

edit_and_stage_file() {
    local file="$1"
    nvim "$file"
    git add "$file"
}


main() {
    local conflicted_files
    conflicted_files=$(get_conflicted_files)

    if [ -z "$conflicted_files" ]; then
        echo "No conflicted files found."
        exit 0
    fi


    echo "$conflicted_files" | while read -r file; do
        edit_and_stage_file "$file"
        echo "Staged changes for $file"
    done

    echo "All conflicted files have been processed."
    git status
}

main
