--[[
documentation: change modification time of pictures/videos
usage: lua metadate.lua <dir>
usage: lua metadate.lua /media/laz/lg/snimki/2018___pixel2/E/
usage: lua metadate.lua /home/laz/Pictures/
dependencies: https://keplerproject.github.io/luafilesystem/
]]

local lfs = require "lfs"



local function doCommand (command)
	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()
	return content or ""
end


-- format: IMG_20190130_112233_1.jpg
local function isMedia (fileName)
	local words = {}
	for word in fileName:gmatch("%w+") do 
		words[#words+1]=word
	end
	
	if  -- media
		(#words == 4 or #words == 5) and 
		words[2]:len() == 8 and
		words[3]:len() == 6 and
		(
		words[#words]:lower() == "jpg" or
		words[#words]:lower() == "png" or
		words[#words]:lower() == "mp4"
		)
		or -- media folder
		(#words == 3 and 
		words[2]:len() == 8 and
		words[3]:len() == 6
		)
	then
		local media ={}
		media.year = words[2]:sub(1,4)
		media.month = words[2]:sub(5,6)
		media.date = words[2]:sub(7,8)
		media.hour = words[3]:sub(1,2)
		media.minute = words[3]:sub(3,4)
		media.second = words[3]:sub(5,6)
		return media
	end -- check
end -- isMedia


local function processMedia (fileName, fileNamePath)
	local media = isMedia(fileName)
	if media then 
		--print("# media: " .. fileNamePath)
		
		local fileDate = string.format("%s:%s:%s %s:%s:%s", 
			media.year, media.month, media.date,
			media.hour, media.minute, media.second)
		
		--if not doCommand("exiv2 " .. fileNamePath):find("Image timestamp : " .. fileDate, 1, true) then
		if not doCommand("exiftool " .. fileNamePath):find("Create Date                     : " .. fileDate, 1, true) then
			print("# update : " .. fileNamePath)
			print(doCommand(string.format("exiftool -AllDates='%s' -overwrite_original %s", fileDate, fileNamePath)))
		end
	else
		print("# no media: " .. fileNamePath)
	end
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


local function processMediaFolder (fromObject, paths)
	for i=1,#paths do
		local fileName = paths[i].name
		local fileNamePath = paths[i].path
		local attrFrom, errFrom = lfs.attributes(fileNamePath)
		if attrFrom and attrFrom.mode == "file" then 
			-- new file name
			local words = {}
			for word in fileName:gmatch("%w+") do 
				words[#words+1]=word
			end
			local newFileName = fromObject.name .. "_" .. i .. "." .. words[#words]
			local newFileNamePath = fromObject.path .. "_" .. i .. "." .. words[#words]
			print("# create: " .. newFileNamePath)
			
			-- copy file to new destination
			local file, err = io.open(newFileNamePath, "w")
			if file == nil then 
				print("# error: " .. newFileNamePath)
				print(err)
			end
			file:write(fileContent(fileNamePath))
			file:close()
			
			-- fix metadata
			--processMedia(newFileName, newFileNamePath)
		end
	end
end


local counter = 0
local traverse
traverse = function (file, func)
	local from, fromObject
	if not file then 
		return
	elseif type(file) == "string" then 
		from = file
	elseif type(file) == "table" then 
		from = file.path
		fromObject = file
	end
	
	local attrFrom, errFrom = lfs.attributes(from)
	if not attrFrom then return end
	
	if attrFrom.mode == "directory" then
		print("# traverse: " .. from)
		
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
			
			if fromObject and isMedia(fromObject.name, fromObject.path) then
				processMediaFolder(fromObject, paths)
			else
				for i=1,#paths do traverse(paths[i], func) end
			end
		end
	elseif attrFrom.mode == "file" then
		counter = counter + 1
		--print("# traverse: [" .. counter .. "] " .. from)
		if fromObject and func then func(fromObject.name, fromObject.path) end
	end
end


if #arg < 1 then
	print("usage: lua metadate.lua <dir>")
	return
end

traverse(arg[1], processMedia)
print("### end ###\n")
