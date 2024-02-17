# Dotfiles


Here, I have my `dotfiles` files and a `bash script` to setup a `fresh vm` with necessary tool to do my job.  
Tested on `Ubuntu 20.10` and `Kali 2020.4`.

# Installing
Just type in your terminal in a *fresh machine*:

````bash
curl -L https://bit.ly/3oSa3HO | bash 

````
> The user must be in ` sudo group`.

For install `bat-extras` scripts that you add some features like colored man-pages  
you have to follow tutorial in [`bat github`](https://github.com/eth-p/bat-extras).

# Installed packages
> For a list the packages that will be install read [bash script](https://bit.ly/3oSa3HO).

# Install individual configuration files

## nvim 

For who what's considering move to `vim/nvim`, I really recommend this channel especially the list in links below:
[Your first VimRC: How to setup your vim's vimrc](https://www.youtube.com/watch?v=n9k9scbTuvQ) 
[Vim As Your Editor](https://www.youtube.com/watch?v=H3o4l4GVLW0&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R)

Before run you must install [`vim-plug`](https://github.com/junegunn/vim-plug). Just type:

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
Now copy the `init.vim` in nvim folder to our machine.

# tmux

`Tmux` is the most save time that I know in terminal. Tmux is a terminal multiplexer.  
I Add some features, like keybinds to send usually commands that I use a lot whithout typing.  
The `bindkey` is `CTRL + A`.

# zshrc

A `zshrc` with some alias, Ones I created myself and other I copy from internet.
