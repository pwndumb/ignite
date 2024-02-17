#!/usr/bin/env bash

######################################################################
# @author      : pwndumb
# @file        : ignite
# @created     : Terça Feira Dez 29, 2020 11:11:39 -03
#
# @description : ignite script to install all necessary tools for pentest
######################################################################

# Colors
RED=$(tput bold && tput setaf 1)
GREEN=$(tput bold && tput setaf 2)
YELLOW=$(tput bold && tput setaf 3)
BLUE=$(tput bold && tput setaf 4)
NC=$(tput sgr0) # No Color

# Print functions
print_color() {
  echo -e "\n$1${2}$NC"
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  print_color "$RED" "This script should not be run as root. Please run as a regular user with sudo privileges."
  #exit 1
fi

print_color "$GREEN" "This script will install necessary tools for pentesting on a fresh VM."
print_color "$GREEN" "The root password may be required."

# Update and Upgrade
print_color "$BLUE" "Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get -y dist-upgrade

# Package installation
print_color "$BLUE" "Installing packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils build-essential jq strace curl wget rubygems gcc dnsutils ncat net-tools vim gdb gdb-multiarch python3 python3-pip python3-dev libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev python3-pip tmux xclip nodejs npm perl binutils rpm2cpio cpio zstd zsh bpython p7zip-full tree hexyl sudo npm rizin-cutter rizin fzf neovim seclists bat ghidra cargo golang gitleaks bloodhound code-oss rlwrap htop btop ncdu ripgrep fd-find docker.io

# Docker configuration
print_color "$BLUE" "Configuring Docker..."
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
print_color "$BLUE" "Testing Docker installation..."
sudo docker run hello-world

# Cleanup
print_color "$YELLOW" "Cleaning up..."
sudo apt-get autoremove -y

# Tool installations
print_color "$BLUE" "Installing additional tools..."

# NetExec
print_color "$BLUE" "Installing NetExec..."
pipx install git+https://github.com/Pennyw0rth/NetExec

# Project Discovery tools
print_color "$BLUE" "Installing tools from Project Discovery..."
GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
export PATH GOPATH
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/cvemap/cmd/cvemap@latest

# GitHub tools and configurations
print_color "$BLUE" "Cloning and setting up tools from GitHub..."
mkdir -p $HOME/Tools && cd $HOME/Tools
git clone https://github.com/pwndbg/pwndbg.git && cd pwndbg && ./setup.sh && cd ..
git clone https://github.com/niklasb/libc-database
git clone https://github.com/JonathanSalwan/ROPgadget
sudo gem install one_gadget
sudo pip3 install pwntools

# Vim-Plug for Neovim
print_color "$YELLOW" "Installing Vim-Plug for Neovim..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# NVIM configurations
print_color "$YELLOW" "Downloading NVIM configurations..."
curl -fLo "$HOME/.config/nvim/init.vim" --create-dirs https://raw.githubusercontent.com/pwndumb/ignite/master/nvim/init.vim

# TMUX configurations
print_color "$YELLOW" "Downloading TMUX configurations..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -s -q https://raw.githubusercontent.com/pwndumb/ignite/master/tmux/tmux.conf | tee -a "$HOME/.tmux.conf"
curl -s -q https://raw.githubusercontent.com/pwndumb/ignite/master/zshrc/zshrc | tee -a "$HOME/.zshrc"
tmux source-file ~/.tmux.conf

print_color "$GREEN" "Installation and configuration complete. Please restart your session for all changes to take effect."


