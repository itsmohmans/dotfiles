# ~/.dotfiles/zsh/functions.zsh
# Custom shell functions.

# -- cd: show onefetch when entering a new git repo -------------
cd() {
	builtin cd "$@"
	git rev-parse 2>/dev/null

	if [ $? -eq 0 ]; then
		if [ "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) ]; then
			onefetch
			LAST_REPO=$(basename $(git rev-parse --show-toplevel))
		fi
	fi
}

# -- Apostrophe markdown editor (flatpak) -----------------------
apos() {
    flatpak run org.gnome.gitlab.somas.Apostrophe "$@"
}

# -- pass completion --------------------------------------------
_pass () {
	local cmd
	if (( CURRENT > 2)); then
		cmd=${words[2]}
		curcontext="${curcontext%:*:*}:pass-$cmd"
		(( CURRENT-- ))
		shift words
		case "${cmd}" in
			init)
				_arguments : \
					"-p[gpg-id will only be applied to this subfolder]" \
					"--path[gpg-id will only be applied to this subfolder]"
				_pass_complete_keys
				;;
			ls|list|edit)
				_pass_complete_entries_with_subdirs
				;;
			insert)
				_arguments : \
					"-e[echo password to console]" \
					"--echo[echo password to console]" \
					"-m[multiline]" \
					"--multiline[multiline]"
				_pass_complete_entries_with_subdirs
				;;
			generate)
				_arguments : \
					"-n[don't include symbols in password]" \
					"--no-symbols[don't include symbols in password]" \
					"-c[copy password to the clipboard]" \
					"--clip[copy password to the clipboard]" \
					"-f[force overwrite]" \
					"--force[force overwrite]" \
					"-i[replace first line]" \
					"--in-place[replace first line]"
				_pass_complete_entries_with_subdirs
				;;
			cp|copy|mv|rename)
				_arguments : \
					"-f[force rename]" \
					"--force[force rename]"
					_pass_complete_entries_with_subdirs
				;;
			rm)
				_arguments : \
					"-f[force deletion]" \
					"--force[force deletion]" \
					"-r[recursively delete]" \
					"--recursive[recursively delete]"
					_pass_complete_entries_with_subdirs
				;;
			git)
				local -a subcommands
				subcommands=(
					"init:Initialize git repository"
					"push:Push to remote repository"
					"pull:Pull from remote repository"
					"config:Show git config"
					"log:Show git log"
					"reflog:Show git reflog"
				)
				_describe -t commands 'pass git' subcommands
				;;
			show|*)
				_pass_cmd_show
				;;
		esac
	else
		local -a subcommands
		subcommands=(
			"init:Initialize new password storage"
			"ls:List passwords"
			"find:Find password files or directories based on pattern"
			"grep:Search inside decrypted password files for matching pattern"
			"show:Decrypt and print a password"
			"insert:Insert a new password"
			"generate:Generate a new password using pwgen"
			"edit:Edit a password with \$EDITOR"
			"mv:Rename the password"
			"cp:Copy the password"
			"rm:Remove the password"
			"git:Call git on the password store"
			"version:Output version information"
			"help:Output help message"
		)
		_describe -t commands 'pass' subcommands
		_arguments : \
			"--version[Output version information]" \
			"--help[Output help message]"
		_pass_cmd_show
	fi
}

_pass_cmd_show () {
	_arguments : \
		"-c[put it on the clipboard]" \
		"--clip[put it on the clipboard]"
	_pass_complete_entries
}

_pass_complete_entries_helper () {
	local IFS=$'\n'
	local prefix
	zstyle -s ":completion:${curcontext}:" prefix prefix || prefix="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
	_values -C 'passwords' ${$(find -L "$prefix" \( -name .git -o -name .gpg-id \) -prune -o $@ -print 2>/dev/null | sed -e "s#${prefix}/\{0,1\}##" -e 's#\.gpg##' -e 's#\\#\\\\#g' -e 's#:#\\:#g' | sort):-""}
}

_pass_complete_entries_with_subdirs () {
	_pass_complete_entries_helper
}

_pass_complete_entries () {
	_pass_complete_entries_helper -type f
}

_pass_complete_keys () {
	local IFS=$'\n'
	_values 'gpg keys' $(gpg2 --list-secret-keys --with-colons | cut -d : -f 10 | sort -u | sed '/^$/d')
}
