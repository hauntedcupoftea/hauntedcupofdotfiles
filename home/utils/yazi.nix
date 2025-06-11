{ pkgs, ... }: {
  home.packages = with pkgs; [
    yazi
    ffmpeg
    p7zip
    jq
    poppler
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      mgr = {
        linemode = "power";
      };
    };
    initLua = ''
            -- Helper function to format Unix permissions into a readable string (e.g., "drwxr-xr-x")
            -- This keeps the main linemode function cleaner.
            local function format_permissions(file)
            	local mode = file.cha.permissions
            	if not mode then
            		return "?????????? "
            	end

            	local s = ""
            	-- File type
            	if file.is_dir then s = "d"
            	elseif file.is_symlink then s = "l"
            	else s = "-" end

            	-- Owner permissions
      	      s = s .. (bit.band(mode, 256) > 0 and "r" or "-") 
            	s = s .. (bit.band(mode, 128) > 0 and "w" or "-") 
            	s = s .. (bit.band(mode, 64)  > 0 and "x" or "-") 
            	-- Group permissions
            	s = s .. (bit.band(mode, 32)  > 0 and "r" or "-") 
            	s = s .. (bit.band(mode, 16)  > 0 and "w" or "-") 
            	s = s .. (bit.band(mode, 8)   > 0 and "x" or "-") 
            	-- Other permissions
            	s = s .. (bit.band(mode, 4)   > 0 and "r" or "-") 
            	s = s .. (bit.band(mode, 2)   > 0 and "w" or "-") 
            	s = s .. (bit.band(mode, 1)   > 0 and "x" or "-") 
            	return s
            end

            -- Cache for Git status to avoid running the `git` command for every single file.
            -- This dramatically improves performance in Git repositories.
            local git_status_cache = {}
            local last_git_dir = ""

            -- Function to get the Git status for a file
            local function get_git_status(file)
            	local cwd = ya.manager.cwd
            	-- If we changed directory, clear the cache and check if the new dir is a git repo
            	if cwd ~= last_git_dir then
            		last_git_dir = cwd
            		git_status_cache = {} -- Clear cache

            		-- Check if we are inside a git repository
            		local handle = io.popen("git -C " .. ya.esc(cwd) .. " rev-parse --is-inside-work-tree 2>/dev/null")
            		local result = handle:read("*a")
            		handle:close()

            		if result:match("true") then
            			-- If yes, get the status for all files in the directory at once
            			local status_handle = io.popen("git -C " .. ya.esc(cwd) .. " status --porcelain -uall --ignored=no")
            			if status_handle then
            				for line in status_handle:lines() do
            					-- The format is "XY filename" where X is index status and Y is work-tree status
            					local code = line:sub(1, 2)
            					local name = line:sub(4)
            					-- Yazi gives us the full path, but git status gives relative, so we match the end
            					git_status_cache[name] = code
            				end
            				status_handle:close()
            			end
            		end
            	end

            	-- Now, look up the status for the current file in our cache
            	local status = git_status_cache[file.name]
            	if not status then
            		return "  " -- Not in the cache means it's an unmodified/clean file
            	end

            	-- Map the git status code to a Nerd Font icon. Feel free to change these!
            	-- Icon reference: https://www.nerdfonts.com/cheat-sheet
            	local status_map = {
            		[" M"] = " ", -- Modified
            		["??"] = " ", -- Untracked
            		["A "] = " ", -- Added
            		[" D"] = " ", -- Deleted
            		["R "] = " ", -- Renamed
            		["C "] = " ", -- Copied
            		["AM"] = " ", -- Added and Modified
            		["AD"] = " ", -- Added and Deleted
            	}
            	return status_map[status] or " " -- Return icon or a question mark for unhandled statuses
            end

            -- The main function for our "power" linemode
            function Linemode:power()
            	-- 1. Permissions
            	local perms = format_permissions(self._file)

            	-- 2. Owner and Group (adjust padding as needed for your system's user/group name lengths)
            	local owner = self._file.cha.owner or "?"
            	local group = self._file.cha.group or "?"
            	local owner_str = string.format("%-8s %-8s", owner, group)

            	-- 3. File Size
            	local size = self._file:size()
            	local size_str = size and ya.readable_size(size) or (self._file.is_dir and ".." or "-")
            	size_str = string.format("%6s", size_str) -- Right-align in a 6-character column

            	-- 4. Last Modified Time
            	local mtime = self._file.cha.mtime
            	local time_str = ""
            	if mtime then
            		if os.date("%Y", mtime) == os.date("%Y") then
            			time_str = os.date("%b %d %H:%M", mtime) -- e.g., "Oct 26 15:04"
            		else
            			time_str = os.date("%b %d  %Y", mtime) -- e.g., "Oct 26  2022"
            		end
            	end

            	-- 5. Git Status Icon
            	local git_icon = get_git_status(self._file)

            	-- 6. Combine everything into a single, formatted string
            	return string.format("%s %s %s %s %s", git_icon, perms, owner_str, size_str, time_str)
            end
    '';
  };
}
