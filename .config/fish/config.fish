# Fix color environment for editors and apps
set -gx TERM xterm-256color
set -gx COLORTERM truecolor
set -gx MICRO_TRUECOLOR 1

alias b "btop"
alias m "micro"

if status is-interactive
    # Commands to run in interactive sessions can go here
end


function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
