#!/bin/sh
set -e

# Do cleanup - move old configs
if [ -d ~/.config/nvim ]
then
	echo Moving old nvim config to ~/oldnvim
	mv ~/.config/nvim ~/oldnvim
fi
if [ -d ~/.vim ]
then
	echo Moving old vim config to ~/oldvim
	mv ~/.vim ~/oldvim
fi
if [ -f ~/.vimrc ]
then
	echo Moving old vimrc config to ~/oldvim
	mv ~/.vimrc ~/oldvim
fi
if [ -h ~/.vim ]
then
	rm ~/.vim
fi
if [ -h ~/.vimrc ]
then
	rm ~/.vimrc
fi

mkdir -p ~/.config/
git clone https://github.com/hladek/vimrc ~/.config/nvim
echo Installed Dano Config into ~/.config/nvim
ln -s -T ~/.config/nvim ~/.vim
ln -s -T ~/.config/nvim/init.vim ~/.vimrc
echo Prepared Symlinks for VIM

if hash vim 2>/dev/null;
then
	vim +'PlugInstall --sync' +qa
fi

if hash nvim 2>/dev/null;
then
	nvim +'PlugInstall --sync' +qa
fi
