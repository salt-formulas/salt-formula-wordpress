#!/bin/bash

#Downloading wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#Installing wp-cli
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# bash completion for the `wp` command
sudo -i

_wp_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}

	IFS=$'\n';  # want to preserve spaces at the end
	local opts="$(wp cli completions --line="$COMP_LINE" --point="$COMP_POINT" --allow-root)"

	if [[ "$opts" =~ \<file\>\s* ]]
	then
		COMPREPLY=( $(compgen -f -- $cur) )
	elif [[ $opts = "" ]]
	then
		COMPREPLY=( $(compgen -f -- $cur) )
	else
		COMPREPLY=( ${opts[*]} )
	fi
}
complete -o nospace -F _wp_complete wp --allow-root

sudo -u ubuntu -i