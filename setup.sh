#!/bin/bash
set -e

echo "Updating package lists..."
sudo apt update

# Essential packages
packages=(
  tmux
  neovim
  git
  python3
  python3-pip
  curl
  stow
  bat
  fd-find
  fzf
  tldr
  fastfetch
)

# Install packages if not installed
for pkg in "${packages[@]}"; do
  if ! dpkg -s "$pkg" &>/dev/null; then
    echo "Installing $pkg..."
    sudo apt install -y "$pkg"
  else
    echo "$pkg is already installed."
  fi
done

# Install Starship
if ! command -v starship &>/dev/null; then
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "Starship is already installed."
fi

# Install NVM and Node LTS
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node LTS if not installed
if ! command -v node &>/dev/null; then
  echo "Installing Node.js LTS..."
  nvm install --lts
else
  echo "Node.js is already installed."
fi


# Install Bun
if ! command -v bun &>/dev/null; then
  echo "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
else
  echo "Bun is already installed."
fi


# Function to safely stow dotfiles
safe_stow() {
  local folder=$1
  if [ -d "$folder" ]; then
    echo "Stowing $folder..."
    stow --target="$HOME" --adopt "$folder" || stow --target="$HOME" "$folder"
  else
    echo "Folder $folder does not exist in repo."
  fi
}

# Link dotfiles
echo "Linking dotfiles with GNU Stow..."
safe_stow bash
safe_stow nvim
safe_stow starship
safe_stow tmux

echo "All done! Restart your terminal to apply changes."
