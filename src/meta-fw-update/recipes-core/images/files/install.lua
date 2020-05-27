-- #########################################################
-- Pre- and postinstallation routines for the update process
-- #########################################################

----------------------------------------
-- Helper functions
----------------------------------------

-- Extends the os library with a function to capture a process output
function os.capture(file)
	local f = assert(io.popen(file, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end

-- Returns whether the given path is existing
function path_exists(path)
	local f = io.open(path,"r")
	if f ~= nil then io.close(f) return true else return false end
end

-- Executes a command 
function exec(cmd)
    -- os.execute returns: bool (successful termination), string (type of exit), int (status code)
	local ret, s, status = os.execute(cmd)
	if status ~= 0 then
		return false, cmd .. " returned with code " .. tostring(status) .. " (by " .. s .. ")"
	end
	return true,""
end

----------------------------------------
-- Preinstallation routine (naming dictated by swupdate)
----------------------------------------
function preinst()
	local out = "Preinstall script: Completed."
	local eMMC = "%%UPDATE_MEM_DEVICE%%"

	local ret = path_exists(eMMC)
	if not ret then return false, "Cannot find eMMC" end

	exec("/usr/sbin/sfdisk -d " .. eMMC .. "> /tmp/dumppartitions")

	
	local old_partitions = io.input("/tmp/dumppartitions")
	local new_partitions = io.output("/tmp/partitions")
	
	-- Check if there are two identical partitions
	local found = false
	local start, size

	local line = old_partitions:read()
	while line ~= nil do
		local match = string.find(line, "%%UPDATE_MEM_DEVICE%%p3")
		new_partitions:write(line .. "\n")
		if match == 1 then
			found = true
			break
		end
		match = string.find(line, "%%UPDATE_MEM_DEVICE%%p2")
		if match == 1 then
			start, size = string.match(line, "%a+%s*=%s*(%d+), size=%s*(%d+)")
		end
		line = old_partitions:read()
	end
	old_partitions:close()

	if found then
		new_partitions:close()
		return true, out
	end

	-- Create a second, identical partition if none was found
	start = start + size
	local partitions = eMMC .. "p3 : start=    " .. string.format("%d", start) .. ", size=  " .. size .. ", type=83\n"
	new_partitions:write(partitions)
	new_partitions:close()
	
	-- Capture the output from sfdisk
	out = os.capture("/usr/sbin/sfdisk --force " .. eMMC .. " < /tmp/partitions")

	-- Use partprobe to inform the kernel of the new partitions
	exec("/usr/sbin/partprobe " .. eMMC)

	return true, out
end

----------------------------------------
-- Postinstallation routine (naming dictated by swupdate)
----------------------------------------
function postinst()
	local out = "Postinstall script: Nothing to be done."
	return true, out
end