--[[
documentation: copy nested directories and their content alphabeticaly to other location
usage: lua copy.lua <from> <to>
dependencies: https://keplerproject.github.io/luafilesystem/
]]

local lfs = require "lfs"


local copyFilePath
copyFilePath = function (from, to)
	local attrFrom, errFrom = lfs.attributes(from)
	if not attrFrom then return end
	
	if attrFrom.mode == "directory" then
		local attrTo, errTo = lfs.attributes(to)
		if not attrTo then 
			print("copy.lua: " .. to)
			lfs.mkdir(to) 
		end
		
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
					if to:sub(#to,#to) == "/" then
						pathTo = to .. entry
					else
						pathTo = to .. "/" .. entry
					end
				else
					pathFrom = "/" .. entry
					pathTo = "/" .. entry
				end
				paths[#paths+1] = {from = pathFrom, to = pathTo}
			end
		end
		if #paths > 0 then
			table.sort(paths, function(x,y) return x.from < y.from end)
			for i=1,#paths do copyFilePath(paths[i].from, paths[i].to) end
		end
	elseif attrFrom.mode == "file" then
		print("copy.lua: " .. to)
		
		local fileFrom = assert(io.open(from, "r"))
		local content = fileFrom:read("*all")
		fileFrom:close()
		
		local fileTo = assert(io.open(to, "w"))
		fileTo:write(content)
		fileTo:close()
	end
end


if #arg ~= 2 then
	print("usage: lua copy.lua <from> <to>")
	return
end

local f = assert(io.popen("rm -rf " .. arg[2] .. "/*", "r"))
f:close()
copyFilePath(arg[1], arg[2])