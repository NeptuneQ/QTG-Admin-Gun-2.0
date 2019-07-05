QAG2M.Name			= 'Set All Player Heath'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Set all players\' health to a value'
QAG2M.IsAutomatic	= false
QAG2M.FireTime		= 0.3
QAG2M.FireSound		= ''
QAG2M.DrawToolTracer= false

QAG2M.Information = {
	{name = 'left',helptext = 'Set Heath'}
}

QAG2M.WeaponInfo = {
	{name = 'Players',text = function(self,t)
		local plys = {}
		
		for k,v in pairs(player.GetAll()) do
			if v != self.Owner and v:Alive() and v:GetActiveWeaponClass() != self.ClassName then
				plys[#plys+1] = v
			end
		end
		
		return #plys
	end,modeonly = true},
	{name = 'SetHealth',text = function(self,t)
		return self.Owner:GetInfoNum('qag2_set_ply_health',100)
	end,modeonly = true}
}

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		if SERVER then
			for k, v in pairs(player.GetAll()) do
				if v != self.Owner and v:Alive() and v:GetActiveWeaponClass() != self.ClassName then
					v:SetHealth(self.Owner:GetInfoNum('qag2_set_ply_health',100))
				end
				
				if SERVER then 
					v:QAGAddNotify(self.Owner:Name()..' Set All Player Health('..self.Owner:GetInfoNum('qag2_set_ply_health',100)..')',NOTIFY_CLEANUP,5,1)
				end
			end
		end
	end
}