#!/usr/bin/env zsh

bindkey -e
 
for file in ~/.{ssh_setup,zsh_prompt,aliases,functions,path,dockerfunc,extra,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done

unset file
