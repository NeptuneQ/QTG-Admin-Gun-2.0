local e 		= FindMetaTable('Entity')
local p 		= FindMetaTable('Player')
local w 		= FindMetaTable('Weapon')
local n 		= FindMetaTable('NPC')

local NOTIFY_GENERIC	= NOTIFY_GENERIC
local NOTIFY_ERROR		= NOTIFY_ERROR
local NOTIFY_UNDO		= NOTIFY_UNDO
local NOTIFY_HINT		= NOTIFY_HINT
local NOTIFY_CLEANUP	= NOTIFY_CLEANUP

function p:QAGAddNotify(m,i,t,s)
	if m == nil then m = 'Notify' end
	if i == nil then i = 0 end
	if t == nil then t = 5 end
	if s == nil then s = ''
	elseif s == 0 then s = 'ambient/water/drip'..math.random(1,4)..'.wav'
	elseif s == 1 then s = 'buttons/button15.wav'
	end
	if SERVER then
		self:SendLua('GAMEMODE:AddNotify(\''..m..'\','..i..',\''..t..'\') surface.PlaySound(\''..s..'\')')
	else
		notification.AddLegacy(m,i,t)
		surface.PlaySound(s)
	end
end

function p:GetQAG2FireMode()
	return self:GetNWInt('QAG2_FireMode')
end

function p:SetQAG2FireMode(a)
	if self:GetActiveWeapon():GetClass() != 'qtg_admin_gun_2' then return end
	self:GetActiveWeapon():SetFireType(1)
	self:SetNWInt('QAG2_FireMode',a)
end

if p.GetActiveWeaponClass != nil then
	function p:GetActiveWeaponClass()
		local w = self:GetActiveWeapon()
		if !w:IsValid() then return nil end
		return w:GetClass()
	end
	n.GetActiveWeaponClass = p.GetActiveWeaponClass
end