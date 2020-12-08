#!/usr/bin/env zsh

bindkey -e
 
for file in ~/.{exports,ssh_setup,zsh_prompt,aliases,functions,path,dockerfunc,extra,complete}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done

unset file

# Created by `userpath` on 2020-12-08 18:16:37
export PATH="$PATH:/home/trevor/.local/bin"
