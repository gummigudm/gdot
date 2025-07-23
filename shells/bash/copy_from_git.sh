#!/usr/bin/env bash

repo_url="https://raw.githubusercontent.com/gummigudm/gdot/refs/heads/initialdev/shells/bash"
get_cmd=""

files=(
    ".bash_profile"
    ".bashrc"
    ".bash_gdot_prompt"
)

## Check existence of curl or wget
if command -v curl >/dev/null 2>&1; then
    get_cmd="curl -sSfL -o "
elif command -v wget >/dev/null 2>&1; then
    get_cmd="wget -q --https-only -O "
else
    printf "Error: Can not fetch profile,\n" >&2
    printf "Neither curl nor wget is available on the system\n" >&2
    exit 1
fi

## Setup bash profile
printf "Setting up bash profile...\n"

## Checking existence of files
for file in "${files[@]}"; do
    if [ -e "$HOME/$file" ]; then
        printf "Warning: File '%s' already exists, do you wish to overwrite? (y/n): " "$file"
        read -r answer
        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            printf "Aborted.\n"
            exit 0
        fi
        rm -rf "$HOME/$file"
    fi
done

## Fetching files
for file in "${files[@]}"; do
    $get_cmd "$HOME/$file" "$repo_url/$file"
    if [ $? -ne 0 ]; then
        printf "Error: Failed to fetch one of the required profile files%s\n" >&2
        exit 1
    fi
done

## Print success message
printf "Gdot simple bash profile successfully set up!\n"
printf "Source new profile:\n"
printf 'source "$HOME/.bashrc"\n'
