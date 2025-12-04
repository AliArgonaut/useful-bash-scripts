#!/bin/bash


# Dot-Up-Pckgs.sh
# v 1.0
# Generate Pacman and AUR package lists with timestamp and store in ~/dotfiles/.pkg-list (manually stow and git push later)

DOTFILES_PKG_DIR=$HOME/stow-omarchy-dotfiles/.pkg-list

TIMESTAMP=$(date +"%Y%m%d-%H%M")

PACMAN_FILE="$DOTFILES_PKG_DIR/pacman_packages_$TIMESTAMP.txt"
pacman -Qqe > "$PACMAN_FILE"
echo "pacman file generated"

AUR_FILE="$DOTFILES_PKG_DIR/aur_packages_$TIMESTAMP.txt"
yay -Qqe > "$AUR_FILE"
echo "AUR file generated"


echo "Package lists updated successfully!"
