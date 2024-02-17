#!/usr/bin/env bash
######################################################################
# @author      : pwndumb (pwndumb@thisistheway)
# @file        : ignite
# @created     : Terça Feira Dez 29, 2020 11:11:39 -03
#
# @description : ignite script to install all necessary tools for pentest
######################################################################

# this came from https://github.com/JohnHammond/ignition_key/blob/master/ignition_key.sh
# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`

function RED(){
	echo -e "\n${RED}${1}${NC}"
}
function GREEN(){
	echo -e "\n${GREEN}${1}${NC}"
}
function YELLOW(){
	echo -e "\n${YELLOW}${1}${NC}"
}
function BLUE(){
	echo -e "\n${BLUE}${1}${NC}"
}

#######################################################


GREEN "This script will install necessary tools to do my job in a fresh VM !!!"
GREEN "The root password will be asked !!!" #&& echo 

# Install packages 

if [ $UID -ne 0 ] 
then

    BLUE "Install some packages from oficial repositories ..." #&& echo 
    sudo apt-get update && \
	sudo apt -y dist-upgrade && \
	sudo DEBIAN_FRONTEND=noninteractive apt install -y --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" apt-utils build-essential jq strace  \
	curl wget rubygems gcc dnsutils ncat kali-desktop-kde \
	gcc-multilib-x86-64-linux-gnu  net-tools vim gdb gdb-multiarch python3 python3-pip python3-dev \
	libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev \
	python3-pip tmux xclip nodejs npm perl binutils rpm2cpio cpio flameshot \
	zstd zsh bpython  p7zip-full tree hexyl sudo npm nodejs rizin-cutter rizin \
	fzf neovim seclists bat ghidra cargo golang gitleaks bloodhound 

    BLUE "Try Install docker ..."
    sudo apt install -y docker.io
    sudo systemctl enable docker --now
    sudo docker run hello-world
    BLUE "Puts user in docker group..."
    sudo usermod -aG docker $USER

    YELLOW "Remove trash..."
    sudo apt autoremove -y --assume-yes

	BLUE "Install vimplug"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

	BLUE "Install netexec"
	sudo apt install pipx git
	pipx ensurepath
	pipx install git+https://github.com/Pennyw0rth/NetExec	

	BLUE "Install tools from project discovery"
	sh -c 'go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest'
	sh -c 'go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest'
	sh -c 'go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest'
	sh -c 'go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest'
	sh -c 'go install github.com/projectdiscovery/cvemap/cmd/cvemap@latest'

else

	RED "Not RUN as ROOT, run with user in the sudo group"
	RED "When ROOT is required , the password will be ask"
	RED "Running as root, aborting"
	exit 127

fi

if [ $? -eq 0 ]
then

	# if first stage complete lets to configuration files
	BLUE "Installed packages." #&& echo
	BLUE "Lets install some tools from github"
	# create toos directory inside home user
	YELLOW "Create Tools directory inside the home user"
	mkdir $HOME/Tools && cd $HOME/Tools 
	
	# clone and insall some tools in github
	git clone https://github.com/pwndumb/pwndbg.git && \
	cd pwndbg && ./setup.sh && \
	cd .. && \
	git clone https://github.com/niklasb/libc-database && \
	cd libc-database &&  \
	cd .. && git clone https://github.com/JonathanSalwan/ROPgadget  && \
	sudo gem install one_gadget && sudo pip3 install pwntools && \
	git clone https://github.com/samoshkin/tmux-config.git && \
	cd tmux-config && ./install.sh

	if [ $? -ne 0 ]
	then

		RED "Something wrong, cant clone something in github aborting ..."
		exit 127

	fi
	
	
	# install vim plug
	YELLOW "Installing vim plug"

	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

	BLUE "Vim-Plug installed"
	
	if [ $? -ne 0 ]
	then

		RED "Something wrong, cant install vim-plug aborting ..."
		exit 127

	fi
	
	YELLOW "Download NVIM configurations..."

	sh -c 'curl -fLo "$HOME/.config/nvim/init.vim" --create-dirs \
		https://raw.githubusercontent.com/pwndumb/ignite/master/nvim/init.vim'

	# execute command inside nvim and exit
	echo 'AA' | nvim -c ':PlugInstall|:x!|q!'
	nvim /etc/os-release -c ':CocInstall coc-python|:x!|x!' 

	if [ $? -eq 0 ]
	then
		
		BLUE "Installed NVIM configurations files from github repo ..."
		# install fzf
		BLUE "Configuring FZF..." 

		echo y | $HOME/.fzf/install

	else

		RED "If the command below get some error. Enter in nvim and type :PlugInstall"
		RED "When the script finish !!!"
	
	fi	

	RED "Install ZSH configurations.Pay attention password REQUIRED..."
	
	YELLOW "Download TMUX configurations..."

	sh -c 'curl -s -q  https://raw.githubusercontent.com/pwndumb/ignite/master/tmux/tmux.conf | tee -a "$HOME/.tmux.conf"'

	if [ $? -eq 0 ]
	then
		
		BLUE "Installed TMUX configurations files from git repo ..."
		sh -c 'tmux source-file ~/.tmux.conf'

		
	else

		RED "Something wrong, cant download tmux.conf from github, aborting ..."
		exit 127

	fi


else

	RED "Something is wrong ... aborting the execution"
	exit 127
fi
