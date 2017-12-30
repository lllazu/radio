--[[
documentation: count files
usage: lua count.lua <from> <mode>
dependencies: https://keplerproject.github.io/luafilesystem/
]]

local lfs = require "lfs"


local function load_file(fileName, environment)
	if setfenv and loadfile then
		local f = assert(loadfile(fileName))
		setfenv(f,environment)
		return f
	else
		return assert(loadfile(fileName, "t", environment))
	end
end

local donotcopy = load_file("donotcopy.lua", {mode = arg[2]})()

local counter = 1
local countFiles
countFiles = function (from)
	for i=1,#donotcopy do if from:find(donotcopy[i], 0, true) then return end end
	
	local attrFrom, errFrom = lfs.attributes(from)
	if not attrFrom then return end
	
	if attrFrom.mode == "directory" then
		print("copy.lua: " .. from)
		
		local paths = {}
		for entry in lfs.dir(from) do
			if entry ~= "." and entry ~= ".." then
				local pathFrom, pathTo
				if from ~= "/" then 
					if from:sub(#from,#from) == "/" then
						pathFrom = from .. entry
					else
						pathFrom = from .. "/" .. entry
					end
				else
					pathFrom = "/" .. entry
				end
				paths[#paths+1] = {from = pathFrom}
			end
		end
		if #paths > 0 then
			table.sort(paths, function(x,y) return x.from < y.from end)
			for i=1,#paths do countFiles(paths[i].from) end
		end
	elseif attrFrom.mode == "file" then
		print("count.lua: [" .. counter .. "] " .. from)
		counter = counter + 1
	end
end

if #arg < 1 then
	print("usage: lua count.lua <from> <mode>")
	return
end

countFiles(arg[1])