--[[
documentation: create new files out of the File Modification Date/Time of pictures
usage: lua metadatereverse.lua <fromdir> <todir>
usage: lua metadatereverse.lua /var/run/user/1000/gvfs/mtp\:host\=%5Busb%3A003%2C009%5D/Вътрешно\ споделено\ хранилище/viber/media/Viber\ Images/ /home/laz/Pictures/
dependencies: https://keplerproject.github.io/luafilesystem/
]]

local lfs = require "lfs"



local function doCommand (command)
	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()
	return content or ""
end


local function fileContent (fileName)
	local file, err = io.open(fileName, "r")
	if file == nil then
		print("# error: " .. fileName)
		print(err)
		return ""
	end

	local content = file:read("*all")
	file:close()

	return content
end



local function getModificationDate (fileNamePath)
	local res = doCommand('exiftool "' .. fileNamePath .. '"')
	local startIndex, endIndex = res:find("File Modification Date/Time     : ", 1, true)
	if startIndex and endIndex then
		return res:sub(endIndex+1, endIndex+19)
	end
end


local fileCounter = 0
local function getFileNameFromModificationDate (fileNamePath)
	local timedate = getModificationDate(fileNamePath)
	if timedate then
		local words = {}
		for word in timedate:gmatch("%w+") do 
			words[#words+1]=word
		end
		return "IMG_" .. words[1] .. words[2] .. words[3] .. "_" .. words[4] .. words[5] .. words[6]
	end

	-- default
	fileCounter = fileCounter + 1
	return fileCounter
end

local function processMedias (from, to)
	local paths = {}
	for entry in lfs.dir(from) do
		if entry ~= "." and entry ~= ".." then
			local pathFrom
			if from ~= "/" then 
				if from:sub(#from,#from) == "/" then
					pathFrom = from .. entry
				else
					pathFrom = from .. "/" .. entry
				end
			else
				pathFrom = "/" .. entry
			end
			paths[#paths+1] = {path = pathFrom, name = entry}
		end
	end

	if #paths > 0 then
		table.sort(paths, function(x,y) return x.path < y.path end)
		for i=1,#paths do
			local fileNamePath = paths[i].path
			local newFileNamePath = to .. getFileNameFromModificationDate(fileNamePath) .. "_" .. i .. ".jpg"
			print("# create: " .. newFileNamePath)
			
			-- copy file to new destination
			local file, err = io.open(newFileNamePath, "w")
			if file == nil then 
				print("# error: " .. newFileNamePath)
				print(err)
			end
			file:write(fileContent(fileNamePath))
			file:close() 
		end
	end
end


if #arg < 2 then
	print("usage: lua metadatereverse.lua <fromdir> <todir>")
	return
end


processMedias(arg[1], arg[2])
print("### end ###\n")