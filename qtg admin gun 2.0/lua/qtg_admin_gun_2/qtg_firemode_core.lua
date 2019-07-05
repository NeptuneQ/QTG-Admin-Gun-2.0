QAG2.FireMode = QAG2.FireMode or {}
QAG2.WeaponInfo = QAG2.WeaponInfo or {}

local function QTG_AddFireMode(a,b)
	if !a or type(b) != 'table' or !b.Name then return false end
	
	-- b.AddToMenu						= b.AddToMenu		or true -- WTF???
	b.Author							= b.Author 			or ''
	b.Introduction 						= b.Introduction 	or ''
	b.IsAutomatic						= b.IsAutomatic		or false
	b.FireSound							= b.FireSound		or 'Airboat.FireGunRevDown'
	b.FireTime							= b.FireTime 		or 0
	b.DrawToolTracer					= b.DrawToolTracer	or false
	b.Information						= b.Information		or {{name = 'left',helptext = 'Fire!!!'}}
	b.FireType[1]						= b.FireType[1]		or {}
	b.FireType[1].TypeName 				= b.FireType[1].TypeName or ''
	b.FireType[1].StartFire				= b.FireType[1].StartFire or function()	end
	b.Reload 							= isfunction(b.Reload) 		and b.Reload 		or function()	end
	b.Deploy 							= isfunction(b.Deploy) 		and b.Deploy 		or function()	end
	b.Holster 							= isfunction(b.Holster) 	and b.Holster 		or function()	end
	b.Think 							= isfunction(b.Think) 		and b.Think 		or function()	end
	b.DrawHUD							= isfunction(b.DrawHUD) 	and b.DrawHUD 		or function()	end
	
	if b.WeaponInfo != nil then
		QAG2.WeaponInfo[a] = b.WeaponInfo
	end
	
	QAG2.FireMode[a] 					= b
	return true
end

local function QTGPrint(a)
	if CLIENT then return end
	MsgC(Color(0,255,255),a..'\n')
end

local path = 'qtg_admin_gun_2/firemode/'
local files = file.Find(path..'*.lua','LUA')

local function QTG_LoadFireMode()
	if SERVER then
		net.Start('QAG2_FireMode_Reload')
		net.Broadcast()
	end
	
	local addn = 0
	
	for _,v in pairs(files) do
		if SERVER then
			AddCSLuaFile(path..v)
		end
		
		local name = string.sub(v,0,string.len(v)-4)
		
		QAG2M = {}
		QAG2M.FireType = {}
		
		local r = file.Read('qtg_admin_gun_2/firemode/'..v,'LUA')
		
		if r != nil then
			RunString(r,v)
			QTGPrint('[QTG Admin Gun 2.0] Loading Fire Mode: '..name)
		end
		
		local add = QTG_AddFireMode(name,QAG2M)
		
		if add then
			addn = addn+1
		else
			QTGPrint('[QTG Admin Gun 2.0] Fire Mode \''..name..'\' missing Name!')
		end
		
		QAG2M = nil
	end
	QTGPrint('[QTG Admin Gun 2.0] A total of '..addn..' fire mode')
end

if CLIENT then
	net.Receive('QAG2_FireMode_Reload',function(_)
		QTG_LoadFireMode()
	end)
end

QTG_LoadFireMode()
hook.Add('Initialize','QTG_LoadFireMode',QTG_LoadFireMode)
hook.Add('OnReloaded','QTG_LoadFireMode',QTG_LoadFireMode)

concommand.Add('qag2_firemode_reload',function(p,c,a)
	if p:IsAdmin() then
		QTG_LoadFireMode()
	end
end, function() end,'Reloads all QTG Admin Gun 2.0 FireMode',{FCVAR_SERVER_CAN_EXECUTE})