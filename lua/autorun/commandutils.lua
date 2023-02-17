--- @diagnostic disable: discard-returns

--- Seperates a string natively.
--- @param str string The string to split.
--- @param sep string The seperator to split the string by.
local function split(str, sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	str:gsub(pattern, function(c)
		fields[#fields + 1] = c
	end)
	return fields
end

--- Uses slice notation on a table.
--- @param tbl table The table to slice.
--- @param start number The start index of the slice.
--- @param stop number? The stop index of the slice. (optional)
local function sliceNotation(tbl, start, stop)
	local sliced = {}
	for i = start, stop or #tbl do
		sliced[#sliced + 1] = tbl[i]
	end
	return sliced
end

--- Splits the command into it's name, arguments, and speaker.
--- @param text string The command to split.
--- @return string name, string args, string speaker
local function validateCommand(ply, text, team)
	local command = split(text, " ")
	local name = command[1]
	local args = sliceNotation(command, 2)
	local speaker = ply:Nick()
	return processCommand(name, args, speaker)
end

local function getPlayerFromName(name)
	for _, ply in pairs(player.GetAll()) do
		if ply:Nick() == name then
			return ply
		end
	end
	for _, ply in pairs(player.GetAll()) do
		if name:lower():sub(1, #nick) == nick:lower() then
			return ply
		end
	end
end

--- Processes the command.
--- @param name string The name of the command.
--- @param args string The arguments of the command.
--- @param speaker string The speaker of the command.
local function processCommand(name, args, speaker)
	if name == 'give_weapon' then
 		local weapon = args[1]
		local ply = getPlayerFromName(args[2] or speaker)
		ply:Give(weapon)
		ply:SelectWeapon(weapon)
		ply:ChatPrint("You have been given a " .. weapon .. " by " .. speaker)
	end
end

hook.Add("PlayerSay", "OnCommandRecieved", validateCommand)
