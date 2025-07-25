#!/usr/bin/env fish

if test "$argv[6]" = 1
    set -x
end

# This wrapper script is invoked by xdg-desktop-portal-termfilechooser.
#
# Inputs:
# 1. "1" if multiple files can be chosen, "0" otherwise.
# 2. "1" if a directory should be chosen, "0" otherwise.
# 3. "0" if opening files was requested, "1" if writing to a file was
#    requested. For example, when uploading files in Firefox, this will be "0".
#    When saving a web page in Firefox, this will be "1".
# 4. If writing to a file, this is recommended path provided by the caller. For
#    example, when saving a web page in Firefox, this will be the recommended
#    path Firefox provided, such as "~/Downloads/webpage_title.html".
#    Note that if the path already exists, we keep appending "_" to it until we
#    get a path that does not exist.
# 5. The output path, to which results should be written.
# 6. "1" if log level >= DEBUG, "0" otherwise.
#
# Output:
# The script should print the selected paths to the output path (argument #5),
# one path per line.
# If nothing is printed, then the operation is assumed to have been canceled.

set multiple $argv[1]
set directory $argv[2]
set save $argv[3]
set path $argv[4]
set out $argv[5]
set cmd yazi

# "wezterm start --always-new-process" if you use wezterm
if test "$save" = 1
    set TITLE "Save File:"
else if test "$directory" = 1
    set TITLE "Select Directory:"
else
    set TITLE "Select File:"
end

function quote_string
    set input $argv[1]
    # Fish string replacement: replace ' with '\''
    set quoted (string replace -a "'" "'\\''" "$input")
    echo "'$quoted'"
end

# Use environment variable or default to kitty
set termcmd (string split " " (string replace -a '$(quote_string "$TITLE")' (quote_string "$TITLE") "$TERMCMD"))
if test -z "$TERMCMD"
    set termcmd kitty --title (quote_string "$TITLE")
end

function cleanup --on-signal HUP --on-signal INT --on-signal QUIT --on-signal ABRT --on-signal TERM --on-process-exit $fish_pid
    if test -f "$tmpfile"
        command rm "$tmpfile" 2>/dev/null; or true
    end
    if test "$save" = 1 -a ! -s "$out"
        command rm "$path" 2>/dev/null; or true
    end
end

if test "$save" = 1
    set tmpfile (command mktemp)
    # Save/download file
    printf '%s' 'xdg-desktop-portal-termfilechooser saving files tutorial
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!                 === WARNING! ===                 !!!
!!! The contents of *whatever* file you open last in !!!
!!! yazi will be *overwritten*!                    !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Instructions:
1) Move this file wherever you want.
2) Rename the file if needed.
3) Confirm your selection by opening the file, for
   example by pressing <Enter>.
Notes:
1) This file is provided for your convenience. You can
	 only choose this placeholder file otherwise the save operation aborted.
2) If you quit yazi without opening a file, this file
   will be removed and the save operation aborted.
' >"$path"
    set cmd_args "--chooser-file="(quote_string "$tmpfile") (quote_string "$path")
else if test "$directory" = 1
    # upload files from a directory
    # Use this if you want to select folder by 'quit' function in yazi.
    set cmd_args "--cwd-file="(quote_string "$out") (quote_string "$path")
    # NOTE: Use this if you want to select folder by enter a.k.a yazi keybind for 'open' funtion ('run = "open") .
    # set cmd_args "--chooser-file=$out" "$path"
else if test "$multiple" = 1
    # upload multiple files
    set cmd_args "--chooser-file="(quote_string "$out") (quote_string "$path")
else
    # upload only 1 file
    set cmd_args "--chooser-file="(quote_string "$out") (quote_string "$path")
end

# Execute the terminal command
eval "$termcmd -- $cmd $cmd_args"

# case save file
if test "$save" = 1 -a -s "$tmpfile"
    set selected_file (command head -n 1 "$tmpfile")
    # Check if selected file is placeholder file
    if test -f "$selected_file" -a (command grep -qi "^xdg-desktop-portal-termfilechooser saving files tutorial" "$selected_file"; echo $status) -eq 0
        echo "$selected_file" >"$out"
        set path "$selected_file"
    end
end
