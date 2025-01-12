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
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
        brew install neovim git lazygit stow
    fi
    
    # Setup dotfiles
    log "Setting up dotfiles..."
}

# Run script
main "$@"
