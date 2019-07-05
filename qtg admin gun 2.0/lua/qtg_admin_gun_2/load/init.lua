QAG2 = {}

-- Convenient for myself

local MODName = 'QTG Admin Gun 2.0'
local DirectoryName = 'qtg_admin_gun_2'
local PrintColor = Color(0,255,255)

local function QTGPrint(a)
	MsgC(PrintColor,a..'\n')
end

function QAG2:Init()
	QTGPrint(SERVER and '['..MODName..'] Loading server...' or '['..MODName..'] Loading client...')
	QAG2:IncludeDirectory(DirectoryName..'/client','cl')
	QAG2:IncludeDirectory(DirectoryName..'/server','sv')
	QAG2:IncludeDirectory(DirectoryName)
	QTGPrint(SERVER and '['..MODName..'] Server loading completed!' or '['..MODName..'] Client loading completed!')
end

function QAG2:IncludeFile(f)
	if !file.Exists(f,'LUA') then return end
	
	if SERVER then
		AddCSLuaFile(f)
		include(f)
	end
	
	if CLIENT then
		include(f)
	end
	
	QTGPrint('['..MODName..'] Loading shared file: '..f)
end

function QAG2:IncludeClientFile(f)
	if !file.Exists(f,'LUA') then return end
	
	if SERVER then
		AddCSLuaFile(f)
	end
	
	if CLIENT then
		include(f)
		QTGPrint('['..MODName..'] Loading client file: '..f)
	end
end

function QAG2:IncludeServerFile(f,t)
	if !file.Exists(f,'LUA') then return end
	
	if SERVER then
		AddCSLuaFile(f)
		include(f)
		QTGPrint('['..MODName..'] Loading server file: '..f)
	end
end

function QAG2:IncludeDirectory(d,b)
	local f,dir = file.Find(d..'/*.lua','LUA')
	
	for _,v in pairs(f) do
		local type = ''
		
		if b == 'cl' or v:StartWith('cl_') then
			type = 'cl'
		elseif b == 'sv' or v:StartWith('sv_') then
			type = 'sv'
		elseif b == 'doc' or v:StartWith('doc_') then
			type = 'doc'
		end
		
		if type == 'cl' then
			QAG2:IncludeClientFile(d..'/'..v)
		elseif type == 'sv' then
			QAG2:IncludeServerFile(d..'/'..v)
		elseif type == 'doc' then
			-- Nothing
		else
			QAG2:IncludeFile(d..'/'..v)
		end
	end
end

QAG2:Init()