#!/usr/bin/env bash


# Exit on error
set -e

# Logging helpers
log() {
    echo "===> $1"
}

error() {
    echo "ERROR: $1" >&2
}

# Check for command existence
has_command() {
    command -v "$1" &> /dev/null
}

# Install package manager if needed
setup_package_manager() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! has_command brew; then
            log "Installing Homebrew..."
            sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	    if [ -f "/etc/os-release" ]; then
            . /etc/os-release
            if [[ "$ID_LIKE" == *"debian"* ]] || [[ "$ID" == "debian" ]] || [[ "$ID" == "ubuntu" ]]; then
                log "Updating apt repositories..."
                sudo apt update
            fi
        fi
    fi
}

# Main installation
main() {
    log "Starting setup..."
    setup_package_manager
    
    # Install your tools here
    log "Installing packages..."
    if has_command brew; then
        sudo brew install neovim git lazygit tmux starship stow
	sudo brew install --cask ghostty
    elif [ -f "/etc/os-release" ]; then
        . /etc/os-release
        if [[ "$ID_LIKE" == *"debian"* ]] || [[ "$ID" == "debian" ]] || [[ "$ID" == "ubuntu" ]]; then
            sudo apt install -y neovim git lazygit tmux starship stow

	    # Install lazygit
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
            rm lazygit.tar.gz

	    lazygit --version
        fi
    fi
    
    # Setup dotfiles
    log "Setting up dotfiles..."
}

# Run script
main "$@"
